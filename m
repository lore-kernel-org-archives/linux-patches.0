Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064337;
	b=CgSrRegj+ZBaT5aq7ARHzrzEtBBDH56SwJdjx5RLopAMepoopbaAnq7ApfXLSajp3Ddy
	 7yPRkPv4lwWFQlLbKv5fk17ujoN1GsVgmqAOZol/fYWU46J3j8PxTCPYYbuTo4jKVQ+54
	 RREYMu/ILhshqFTohrhYSlJEjm0c/zcyZD9fExvcjrcUy5UkLvN4govolI7EjkbRXoRX1
	 BctMXTzysMM5qxCWNj1E/DUwl0gpDDktckoU0viTzlu1GEuolR2lIi7VJ9nQ5beV7lb1z
	 Sb+GKGFEgdtmAchpt/y0Nc2LO3mBnYxl0Nm4LbHy7eiPnrjwsZWjQsynAVA/wy5dGBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EIjKev7T9n/sC1Ipz/7dSq7D1KhTiyUCkcWGdCKvlrs=;
	b=Xa44URxirRr/hpxIO0JpgWxqg89NPRODHmuKavuxe7M4xvTqyr0ibK1HVVF9r9nQzcIq
	 j3d6wxHDP32WY8V9afO6u40GGUzef3pHHqtYd+XRxuCJZpD4FFGDIOG3f8V7wrtq3Kn4L
	 EXpuqe0xOs/KtExxhmqfyYw9QqnykFRma3TGOu6OK8lJHXefP5/8ROA2gOphnuwh7enYv
	 nTkpgGrFNLCg4qo9kyB3mnWRwvgjIlLwF/xiMxsUNA3BXVgS2Y6ST8UduYCFxwia3a2jK
	 2tiRDD7cke/6ojJ4U2pUOCCkVq+NdHWve5h45Ma7WyUoom+nDD428y5MYbgMDF4GGKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUNV4uDY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A091606A33A;
	Sat,  7 Nov 2026 15:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sUNV4uDY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302271F0089F;
	Sat,  7 Nov 2026 15:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064337;
	bh=EIjKev7T9n/sC1Ipz/7dSq7D1KhTiyUCkcWGdCKvlrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUNV4uDYJUHpfaylH2sEz+CVT8Xf0AXsFL2W+TcgWpWSuEHT6ox9RaO4ao92EKUni
	 AV4vRTAB4Lg4ZF7FIUyIjx46+xV2MCDETqBWLazGTIOrNYcEK1Jrv8DM6MB54FymKP
	 eOw8RVX24dRQo49RSCKpsiyHR1U2C2RMV6RHVpPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srish Srinivasan <ssrish@linux.ibm.com>,
	R Nageswara Sastry <rnsastry@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0384/1257] pseries/plpks: hide wrapping_features when unsupported
Date: Sat,  7 Nov 2026 08:44:40 -0500
Message-ID: <20261107134950.155363301@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Srish Srinivasan <ssrish@linux.ibm.com>

[ Upstream commit 46b8411b2ee948b1786bc4af76e7feede0c2ddff ]

The PLPKS wrapping features config is only valid on systems that support
the "Key Wrapping" feature. Currently the config is always exposed, even
when the feature is unavailable.

Add an is_visible() callback to suppress the wrapping_features sysfs
attribute when the "Key Wrapping" feature is not supported. Declare the
attribute group static const, as it is not modified after initialization.

Fixes: 447eb1d5ef00 ("pseries/plpks: expose PowerVM wrapping features via the sysfs")
Cc: stable@vger.kernel.org # 7.0
Signed-off-by: Srish Srinivasan <ssrish@linux.ibm.com>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260923182816.151451-10-ssrish@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/plpks-sysfs.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/plpks-sysfs.c b/arch/powerpc/platforms/pseries/plpks-sysfs.c
index c2ebcbb41ae39..f2436229f3233 100644
--- a/arch/powerpc/platforms/pseries/plpks-sysfs.c
+++ b/arch/powerpc/platforms/pseries/plpks-sysfs.c
@@ -45,6 +45,16 @@ static const struct attribute *config_attrs[] = {
 
 static struct kobject *plpks_kobj, *plpks_config_kobj;
 
+static umode_t plpks_config_attr_is_visible(struct kobject *kobj,
+					    struct attribute *attr, int n)
+{
+	if (attr == &attr_wrapping_features.attr &&
+	    !plpks_wrapping_is_supported())
+		return 0;
+
+	return attr->mode;
+}
+
 int plpks_config_create_softlink(struct kobject *from)
 {
 	if (!plpks_config_kobj)
@@ -52,13 +62,13 @@ int plpks_config_create_softlink(struct kobject *from)
 	return sysfs_create_link(from, plpks_config_kobj, "config");
 }
 
+static const struct attribute_group config_group = {
+	.attrs = (struct attribute **)config_attrs,
+	.is_visible = plpks_config_attr_is_visible,
+};
+
 static __init int plpks_sysfs_config(struct kobject *kobj)
 {
-	struct attribute_group config_group = {
-		.name = NULL,
-		.attrs = (struct attribute **)config_attrs,
-	};
-
 	return sysfs_create_group(kobj, &config_group);
 }
 
-- 
2.53.0



