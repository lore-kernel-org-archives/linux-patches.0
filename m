Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86221386441;
	Sat, 12 Sep 2026 19:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242372; cv=none; b=KSk248ZQRdQe4Zk80NIhBSeFReLuxxrw9e1uI4tDwYZBcxzAKjJNl7iIWBqE+ECrXZ4HDl7s5qTCk9/m1mjttGg67ITNnxaSImdh5FAyH4mAImtKz4VVrS3g/i7oUsFdFKLJlqs3rMlWxgIx2okbLrW0WPZbVkAroDR+DJfbdmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242372; c=relaxed/simple;
	bh=uquzk9rd38JolZw0S+n5aiXayMIvM2BF/ALQ28pyLS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsusjM1QkYS+vWN+uATwrgzmHHSJ28Y6TC7ainm7Urn84ltYl4e7Y5KALelGYVV7yym741VpHG2Lg/P/g3LXcqDSguRoGONAgyyMR8hNJG4rCyFzwE/kTUjTbPfdv91ikjM9NaVQSqqzB/nwZZUKPrNBPi0fwKqxc8rlA5incZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isHvPizx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isHvPizx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26531F000FF;
	Sat, 12 Sep 2026 19:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242371;
	bh=5jBPVxx6F+XRgMH1ztJVP5xNdsc3YVR3PHUfJJ84gSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=isHvPizxF1aBtylnfeRpbLHIT7qTierfFPPaFBaOm8TlSIeXER2uFJscP3v1R5/Cf
	 JP17k6qtjijGufAXjl8ap4zuuMREzzfen3fAeaVSLEJtrmzBcmHseJHrONl9keJTjS
	 2ziOdUNFE2cXroiGEqPuI2g2WXGP16M5YHjO/Esg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Austin Kim <austin.kim@lge.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 337/798] smack: mark smack_enabled global variable as __initdata
Date: Sat, 12 Sep 2026 08:59:25 +0200
Message-ID: <20260912065524.886506462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Austin Kim <austin.kim@lge.com>

[ Upstream commit bfc3cac0c76126995737f1b858d2cdb476be5b1d ]

Mark 'smack_enabled' as __initdata
since it is only used during initialization code.

Signed-off-by: Austin Kim <austin.kim@lge.com>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Stable-dep-of: 577dc3b6a8cf ("smack: deduplicate smackfs/{direct,mapped} file_operations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/smack/smack.h     | 2 +-
 security/smack/smack_lsm.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/smack/smack.h b/security/smack/smack.h
index c830d2e111da9..da43345be65d9 100644
--- a/security/smack/smack.h
+++ b/security/smack/smack.h
@@ -303,7 +303,7 @@ int smack_populate_secattr(struct smack_known *skp);
 /*
  * Shared data.
  */
-extern int smack_enabled;
+extern int smack_enabled __initdata;
 extern int smack_cipso_direct;
 extern int smack_cipso_mapped;
 extern struct smack_known *smack_net_ambient;
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 909952cd784d2..c8ba7c27d0435 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -54,7 +54,7 @@
 static DEFINE_MUTEX(smack_ipv6_lock);
 static LIST_HEAD(smk_ipv6_port_list);
 struct kmem_cache *smack_rule_cache;
-int smack_enabled;
+int smack_enabled __initdata;
 
 #define A(s) {"smack"#s, sizeof("smack"#s) - 1, Opt_##s}
 static struct {
-- 
2.53.0



