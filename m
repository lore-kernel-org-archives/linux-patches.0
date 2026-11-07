Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063684;
	b=lAVFN85N22DrtNE/8bu3f7WbWEIxUDVIJ2m3mVOaBIPIPd9ose3q++gn2oUuAjuiOf98
	 YIPj/RY94zdjW74APjhRf9ifd47Vr2kHrEDaVUUMeKTOmyNqhHx8tDp/YQ+fqX4ka3UYQ
	 RdGqSny2bP+e5kMxWPP0QyPTC00BY4rdf73wso1yZRsP+FJxemYdHNqnme1muzkxg+afj
	 QuJUjJcULTMhS0mrKV3vfKevA9nsRD8dgAiJZn7xIvHCvGYOHweIXFEJxH7AI5NfZU0tC
	 JK5OAtWvjcR1z1WoJYaR5kISuDgLQzMdd10Vd2HySNTVZotTFLqJC0wI3kgnnmdfmvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9vPZr5FLn8D2zcHSUgGqYnnTfdnx2H5gkjTrq5gxxfc=;
	b=pVNfxQLxWGedaj4QrHfTWKfXusblx9W4jjmpSuhGdgaJdNHkdk+hxdEz03tt15wRJ0Jm
	 uvXEBz+e7kxEVHkfSX/IlFKWUE2cv8P1d4u3XJUqlDv8itOMXI8vlm/p1yj13Y0YpLSUj
	 P/37D5IgFhu4lXnXsba8oGR/g25SHuA5skNVCE6vRjCTT39ZNYvv4YIyBSidjvEWkcgOT
	 TtQ7WAgtolrZQpCzQUvTZ/McRfbhWs8mfAbZePPh3oJl9XWZTjzmmX78hxth0MVdjJshZ
	 vYf/kML3i95brmu8eRlAIJcFchlcwHvgVjYRbazzCLa7g8BLJSgtV7FAyHmsW9nIPdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=onFl7KWW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667B4606A33C;
	Sat,  7 Nov 2026 15:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=onFl7KWW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA891F0089F;
	Sat,  7 Nov 2026 15:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063684;
	bh=9vPZr5FLn8D2zcHSUgGqYnnTfdnx2H5gkjTrq5gxxfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=onFl7KWWjhAr+NQ+lMRNv2edvB6k2Q/Hn6Pwf/Ugnt8Al9nCafsL/62bsKmt1m9qE
	 dfw29OwFhi0d1LnWBAwuVJbVhTJ4cSlEEY5i++adFspCahA+KBqgqidXjzjL0K0I52
	 xsfCXtKa/SSuUo++6YMp7t6zRFR5PyOY2NDxJE48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 765/869] KVM: arm64: Set HCR_EL2.BSU to Inner Shareable for guests
Date: Sat,  7 Nov 2026 08:57:27 -0500
Message-ID: <20261107134918.651115518@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 00e73757518020273ccf6308a51f214e58c21ad5 ]

KVM sets HCR_EL2.BSU to Inner Shareable for guests, so that a guest's
barriers cover the TLB and I-cache invalidations that HCR_EL2.FB
broadcasts. However, since HCR_BSU_IS became an alias of the generated
HCR_EL2_BSU_IS, it is the unshifted field value 0b01, which sets bit
0 (VM, already set) and leaves BSU at 0b00. A guest's DSB NSH is then
not required to wait for a broadcast TLBI to complete on other CPUs.

Build the field with SYS_FIELD_PREP_ENUM().

Fixes: d0f39259eff4 ("arm64: sysreg: Add layout for HCR_EL2")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20261016081558.805411-1-fuad.tabba@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 1da290aeedce7..641276868a653 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -98,7 +98,7 @@
  * TID1:	Trap REVIDR_EL1, AIDR_EL1, and SMIDR_EL1
  */
 #define HCR_GUEST_FLAGS (HCR_TSC | HCR_TSW | HCR_TWE | HCR_TWI | HCR_VM | \
-			 HCR_BSU_IS | HCR_FB | HCR_TACR | \
+			 SYS_FIELD_PREP_ENUM(HCR_EL2, BSU, IS) | HCR_EL2_FB | HCR_EL2_TACR | \
 			 HCR_AMO | HCR_SWIO | HCR_TIDCP | HCR_RW | HCR_TLOR | \
 			 HCR_FMO | HCR_IMO | HCR_PTW | HCR_TID3 | HCR_TID1)
 #define HCR_HOST_NVHE_FLAGS (HCR_RW | HCR_API | HCR_APK | HCR_ATA)
-- 
2.53.0



