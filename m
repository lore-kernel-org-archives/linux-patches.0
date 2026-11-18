Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016787;
	b=CHUZ6TS9RkuCdycyNbapGgxo/1xjaGPyH+1lYhrfyghR8baaR/fzxgle4gHgcXQ0mejY
	 EylrIRgb3+b6fmXrVo1gmo+EEiXK67KmTlpdUvKDxkRjE2iakzdbd/ui9OmWtbB3i8JY4
	 Gi5HuU6I2yIy54FSqsUFIZnN5CtPH/ODSiFbwx4oahfAg+q1VMRS8gUx94C+qB5ezORPE
	 7Oa7CtkUWgOf+a1zOqbbhPTKZndGsF3ffm7I37QjatEU8Z8iq3RWZ7F4Fl+c5vKQZHY5C
	 fC9ebjbWC5HvSZpwzPI66npaOvkHwx+hXTwUDFeam1Xph25kxPc8eI9ZJs86tt2/YgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lsOlx5Mbnez3RX9sZypn9Wue02/9lSEBlcLJYoW1tSY=;
	b=j8mFgy6S7xGgG8J8eiROCfKUWVvVqfWZYkRBOjvuA6JpyH/5xuHNtzBrxeMWO9aX0pr4
	 olQTLZOwgd9XLGdtn4yxh+ZZ8dtkOdoTRzLkLFla/ctBprSorx5gMpZ+o1hBBjDkfpkgZ
	 nGueBMDBW6FTiUNf5GTs1Q3wN246SYM4rHkESYMqixz/2Q+O9I1umAlIGow4r0YxI/FOR
	 DiSL6w1U8mIk8sviLAN6sI8DOnGc0DeYHZRoV/ybScTnw0fYniMFLwoNhNHg4YRj0bqZy
	 teXiwHr/l34rliCF+gRe14Y3V0Lh5VWUpPnxcc3eyflujstq3MV0q1Izhbsh8g/x3yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BXm7wUqt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD84606A338;
	Wed, 18 Nov 2026 15:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BXm7wUqt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335801F000C8;
	Wed, 18 Nov 2026 15:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016787;
	bh=lsOlx5Mbnez3RX9sZypn9Wue02/9lSEBlcLJYoW1tSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXm7wUqth7A/t+7D/aqTdxQ0k7mOTr3bLLXVPVR3AZc+VG5pCP7EVrsGhtznXRNMv
	 FhV3FK4rD6ZM9FyD9DmfZvp9Y2BpWCB1wCU0YTVff9S7mB2rEiAJSOeIjkEI6DmkEz
	 FcbbzMwQW+pn0pXy2R8pk6VC1h1T2n5R2y6DoPDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0612/2651] pmdomain: renesas: r8a78000: Fix lockdep false positive
Date: Wed, 18 Nov 2026 15:30:52 +0100
Message-ID: <20261118150309.747197631@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit ddacdefc38200bafa35e79925bbc1f4b1fdf41a8 ]

Lockdep reports a possible circular locking dependency when attaching
devices to an MDLC PM domain:

  - During creation of the singleton PM domain:
      A. r8a78000_genpd_always_on_singleton() takes r8a78000_mdlc_lock,
      B. pm_genpd_init() takes gpd_list_lock.

  - During attachment of devices to PM domains:
      A. pm_genpd_add_device() takes gpd_list_lock,
      B. r8a78000_mdlc_attach_dev() takes r8a78000_mdlc_lock.

As the former is done only once, before any devices are attached, such a
AB-BA deadlock cannot really happen.  Fix this false positive by
introducing a separate lock to protect the creation of the singleton
domain.

Fixes: 9f79f93963b0 ("pmdomain: renesas: Add R-Car X5H MDLC driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/renesas/r8a78000-mdlc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pmdomain/renesas/r8a78000-mdlc.c b/drivers/pmdomain/renesas/r8a78000-mdlc.c
index 2668fc2ac9cbd..1fd71bb3da776 100644
--- a/drivers/pmdomain/renesas/r8a78000-mdlc.c
+++ b/drivers/pmdomain/renesas/r8a78000-mdlc.c
@@ -45,8 +45,9 @@ struct r8a78000_mdlc_priv {
 };
 
 static struct generic_pm_domain *r8a78000_genpd_always_on;
+
 static HLIST_HEAD(r8a78000_mdlc_list);
-static DEFINE_MUTEX(r8a78000_mdlc_lock);	/* protects the two above */
+static DEFINE_MUTEX(r8a78000_mdlc_lock);	/* protects the list above */
 
 static struct generic_pm_domain *r8a78000_genpd_xlate(
 			const struct of_phandle_args *spec, void *data)
@@ -191,10 +192,11 @@ static void r8a78000_genpd_del_provider(void *data)
 
 static int r8a78000_genpd_always_on_singleton(struct device *dev)
 {
+	static DEFINE_MUTEX(singleton_lock);
 	struct generic_pm_domain *genpd;
 	int ret;
 
-	guard(mutex)(&r8a78000_mdlc_lock);
+	guard(mutex)(&singleton_lock);
 
 	if (r8a78000_genpd_always_on)
 		return 0;
-- 
2.53.0



