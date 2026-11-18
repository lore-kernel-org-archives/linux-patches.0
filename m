Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039756;
	b=Q1LObYkHY5EB42dEKu9O/GZCjXXkCf9xwbpssBzgZeNEHNnOKFjrxtBku4/EZpGOW80d
	 przf1AM5JC/nqi/BGPSNAoHTagDXzCBa02WZlMDfvCmr8qfKVM5EnMavR//gh8+2remj7
	 CQ38aaNC9Py3nJPdt1m62CVY18SBJD3Surdr2H/IDxhdIEiA5L8webDZ/gKf4AxFdyuca
	 xEju8YwrHFKzriKt7hriGPb7Ksq+EMfkwitTq/5eiM5+on9Kh/OcG92HmXJ03L7purxUR
	 Zg8mzlNVLsW2dSwjOODi/3oEB8t5ctJUsB68wE51IQNIVni0SfQb8rR2XNCA3wx8S9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rnMI4vyg7imqW+UsOsunJhY9sI5vN16U4NUA5Cy0HZE=;
	b=BlZFpMdnNMftka/Ikr2+3icLFDgPGU2N6YCOOeWhdL194dV5/dvDppkIOnYqM3UjrbNG
	 LfnwwPEtP/oWyWmGLbrHtiaiPQMSVkRBVPKM+6u6d/X9ICqIABBGvaL9Q+el1tdo6qGPS
	 ZOyaX0cHmMK9ujUIgfDNtj9n61OWLWBnra8vaFZGf0DDSoWKwZ/PGY9pjunwxJS9yVqky
	 4+IFfKegq5e1u6/gC6yHr4OIBTeVxhbMIUIlvcygbKD5rO+7tJgA7fUUG+0FbZDsZxBXG
	 oJyuTxMfIdwrp/jCcZbxonx2g+n+nGKBcrZ2iTmmuucVppA2x1IceAgsMIUrh7eyFUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wItSqTCH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82FB9606A325;
	Wed, 18 Nov 2026 22:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wItSqTCH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69441F000C4;
	Wed, 18 Nov 2026 22:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039756;
	bh=rnMI4vyg7imqW+UsOsunJhY9sI5vN16U4NUA5Cy0HZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wItSqTCH5sNfiYSjEP95SkFDXTNM12lgucjBM0UOg6go/5OtGlfHUlzUvKh2K8U2C
	 IFxPitVKKsE61nn0tudJePltLcMmEN0ue4FCUqkzhkT4WMJJdZB3oly5XTMaEi2Rwv
	 Q/gxNNaNihVkIohlKS/AvtxxLoKmih5yp9m2IA6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2213/3318] arm64: pi: Run the source checker on the libfdt objects under C=2
Date: Wed, 18 Nov 2026 15:47:15 +0100
Message-ID: <20261118150428.296531061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 44b14ff4aebeae98663d0fd424b4ef88237ee981 ]

The custom lib-%.o rule reuses rule_cc_o_c, which hooks the source
checker only for C=1, and that only when the object is rebuilt. The
C=2 hook, cmd_force_checksrc, hangs off the standard %.o rule, so
"make C=2" silently skips the two libfdt objects. Call
cmd_force_checksrc after the compile rule, as the standard rule does.

Fixes: aacd149b6238 ("arm64: head: avoid relocating the kernel twice for KASLR")
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260901140326.3812068-7-fuad.tabba@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/pi/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/pi/Makefile b/arch/arm64/kernel/pi/Makefile
index 4c0ea3cd4ea40..27d65e42394f2 100644
--- a/arch/arm64/kernel/pi/Makefile
+++ b/arch/arm64/kernel/pi/Makefile
@@ -29,6 +29,7 @@ $(obj)/%.pi.o: $(obj)/%.o FORCE
 
 $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
 	$(call if_changed_rule,cc_o_c)
+	$(call cmd,force_checksrc)
 
 obj-y		:= kaslr_early.pi.o lib-fdt.pi.o lib-fdt_ro.pi.o
 extra-y		:= $(patsubst %.pi.o,%.o,$(obj-y))
-- 
2.53.0



