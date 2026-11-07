Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063094;
	b=fCiIjsa4eux6kaqzuzSJXdtem46YXsPQMMIl9ikQlXnjkDLZzyhMfzz1FGNoeCZkmY+D
	 9JFpw9uv5tr9HFeSTLenfRUMSo556kLfZjWqin0GFtcbQGZvtG2tkaJtQhGqExB70hCuo
	 QZeObbBvFw8gwiQ1XiLfakCCExGRqpz4JasJDD2tMKrM97zoULbtGHzsDyXmuR2kyetDX
	 i/6EqoZPJI3Oafj1awkHjwcbwC/bGLR0YEGClIjOGraF8SWSmgVh9uJvb1hlHLL7XNQl2
	 ijQPEC0Aw5t9kyt4K6M4lIim+dnpc8pRVw78iBP2Keg6NN85qJPhtVzTE12/cLyxfDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YXcJ9NtaqqMH+6Uyb4ZcmN/OQGhS1dmvEpab2uQzM58=;
	b=GyZ/J/mB8Qc+T5pq3TvMx5zlpxDE29uCei295lW/Fvha+oKp3W/iwv557oowCJFe9G4D
	 leIMNgJVef1B+quOiFNON3Bjs+y3QMJtCW+9ri1X7cW5AgtRVCAomNRPy7ioqf2RClD8V
	 8cmxueZyL32V5lS5sXUZkKztxfob+rY6SEKVbKWm1zCZY0sqIyw1thSdcIkC6M0zfqtMD
	 m54P07O4vAgKa+iSZ1mJs0SmJSrs2dlxHi22GeAffHow9jvbVWsjYqK3K/97hBh4OvhSv
	 ezuxX5OZxBZWRZPU4yqto7o+6op948PtnxkGGx5zevsffa5TusgwaeiM5pXSe0ptHhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fA8ynukr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EC3606D804;
	Sat,  7 Nov 2026 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fA8ynukr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E8F1F0089F;
	Sat,  7 Nov 2026 14:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063094;
	bh=YXcJ9NtaqqMH+6Uyb4ZcmN/OQGhS1dmvEpab2uQzM58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fA8ynukr17EbmGQsus75D0uMcTY7s7hpS1RxECgMUQ+DKvQJa7u/h9+Zb4OAzBwOU
	 +ghbWwUxW8MKSInWQ5MMhLt2o2sVXYGnf5m7jMNaRq7UYH8r9rpiDwBfGqwy/rJOy3
	 h4y+h/AEcu+epnGlMKHpuaMdfTPTSiCIJUWFOuc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 330/869] hwrng: core - reject unknown RNG names
Date: Sat,  7 Nov 2026 08:50:12 -0500
Message-ID: <20261107134903.620902369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 7e7be8815143751c20260f80cb4e7fe14dd24b74 ]

In rng_current_store(), err is 0 after successfully locking rng_mutex,
and if the requested RNG name cannot be found, the function reports
success even though the current RNG was not changed.

Set err = -ENODEV before searching the RNG list to reject unknown names.

Fixes: 142a27f0a731 ("hwrng: core - Reset user selected rng by writing "" to rng_current")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 054ffbc9e4220..6412bfa792a29 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -381,6 +381,7 @@ static ssize_t rng_current_store(struct device *dev,
 		cur_rng_set_by_user = 1;
 		drop_current_rng();
 	} else {
+		err = -ENODEV;
 		list_for_each_entry(rng, &rng_list, list) {
 			if (sysfs_streq(rng->name, buf)) {
 				err = set_current_rng(rng);
-- 
2.53.0



