Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060582;
	b=bnIGiy/QmbwRlRTsz5TaFGcO9rtUN7eCu5/K28LgPVUoYBRgTRd9Ak+MOCK1uz1YHLYr
	 +jOJMQmMuNR/sLv4DqksbCTKnCVIFVpRqBc0X3jVeZ6/94bZRQQS3g/Pbd4WCvxafKc3P
	 sb9mSAE/DxCAoNpJFY31pXZxgu1/CBeQFDSfpR5i589FcjVBb7wwuQUQbnnuXWWz8B2hX
	 KwThDnzKf27wphQQp3iuK6MRD8RUkHF2U6BWK5zSHg2HbXdSjyZFrvM0DUWueDGCl7BRX
	 dMlk2Kc/PZvReXpOYjAKty16PfnJYzlcu/RrQVmE0kDE5361h5AL1H3lDF/PLMPksfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rm3tm0JJ1FdUTtt0pE9RtRJmYnxceH0Tjy+/ylhOeJo=;
	b=oSfyk1Ue+VDav0JnH0gyKiaUskiIHQ2MM7bacZypnUCIqBMov+oC39FQlInUb7Zn7XAt
	 1fMOSAgIVI4MMf9S+Fzu/hb0wshTUoHfZtiQfgihalRR60IjAzLO5RnyYG8VTTI8QxBnN
	 x9urJxZuq912zybqKsI6IlU8S2EbMmSKaB19WL7DRLNqP/T0wj8gEMj6+KJrEOeZ2/cuw
	 E5xVs9V0mCAnqeA6G00lvBLp/+4WggH0feoR6IiLVBgC1C/YNM9QChqeQorUZ1yhEwYM2
	 Yhcioik79rU+jntS/IANFQCd3I+BrHWMECt9UlLGfA81ZWLEa/E1YdA7iDLlHRWjZAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfCVfZTI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684DC606A331;
	Sat,  7 Nov 2026 14:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfCVfZTI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0701F0089F;
	Sat,  7 Nov 2026 14:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060582;
	bh=rm3tm0JJ1FdUTtt0pE9RtRJmYnxceH0Tjy+/ylhOeJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfCVfZTIcMb1ChHWS5wLVQEM/unm6vMRA24A7W3AOjvApY3wkYKfTzLt1465VBCiB
	 kCBA5WKZBn1n7A42tAdO1raWVYys4oIMUdLrlxPq8jnlu9TuI9dxaChbXpkMkDoX09
	 g6tl49OwFpYs/NtaXATlj+h2h8oqOjOoT8olAgEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0013/1536] mm/damon/sysfs: put target pids for apply_inputs() failure
Date: Sat,  7 Nov 2026 08:33:49 -0500
Message-ID: <20261107134958.052882096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

damon_sysfs_build_ctx() invokes damon_sysfs_apply_inputs() for setting
damon_ctx object with user inputs.  If it is configured for virtual
address spaces monitoring, the setup also increases reference counts of
monitoring target pids.  If the setup is failed, damon_sysfs_build_ctx()
deallocates the damon_ctx object without decreasing the reference counts
of the pids.  If the failure happened after increasing reference counts
of pids, the pids can be leaked.

Fix the leaks by decreasing the pid reference counts before deallocating
the damon_ctx object.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260730040740.140836-1-sj@kernel.org

Fixes: 74bd8b7d2f8e ("mm/damon/sysfs: move targets setup code to a separated function")
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b3ce45d66ac65..751e6e6cf4386 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1486,6 +1486,7 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 
 	err = damon_sysfs_apply_inputs(ctx, sys_ctx);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return ERR_PTR(err);
 	}
-- 
2.53.0



