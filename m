Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3BF340280;
	Fri,  7 Aug 2026 15:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115295; cv=none; b=dLd4xNB7yilGE22FLQ89Pb45SASfmSiJQFiF4UKXrAhahV1u/w2z0BNUU12hA706qqK00yRj6lo83c3ELA+o0+PS2mY63y+E4+61fZC+/UqOuaXaz9Z34Oy781hTkemRvCKQIFyvtBYGfEsyREgf50WolxiCwt6sAUky8kk27is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115295; c=relaxed/simple;
	bh=Op5YGpks9PGg2mWIGUakd2ecGQqrWGRZfsfnWVtMNCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeYPN2DbWLBmiWtJPq7syvXA0EQEYnWbLvWiFCjJ+QSHmCC6dZ23is/XW8Wm5UJVVk6mjMPIr1pc6s5Y81kKqFKTFZAqFGFa6blc8I/Pofisv9eqAYYefY6vx1pV5hl7C6KaPHD/nwfjmnGM4m6SCxsmM6LpUeli92nqHE/Sbx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wu4o9z51; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wu4o9z51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257171F000E9;
	Fri,  7 Aug 2026 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115294;
	bh=XqlrJ17HUwbJek0CIZ84Mm6x/ZALLSPXAs+SxUAkD20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wu4o9z51DyRq+Uf6GCRdyE098a46gwcD1TLR2NMHqq8minuFweH6wFyxkL4AYkBJ8
	 IsvTBURWsfVxj4gkVv7TZaE4lcnMycyXZTFTnCX6G8zzSGuV1NRRZH2+QWWZF04jHX
	 TVVV7X3agdhxlw59cZu81vXkADRH1Ht5JAwb+LW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 6.18 225/396] mshv: fix hv_input_get_system_property struct
Date: Fri,  7 Aug 2026 16:36:25 +0200
Message-ID: <20260807143429.116552733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Liu <wei.liu@kernel.org>

commit d6f0248f04a96249660591e47fcf37ba98ac7ea3 upstream.

Keep it in sync with the correct definition.

The old code worked by chance.

Fixes: e68bda71a2384 ("hyperv: Add new Hyper-V headers in include/hyperv")
Cc: stable@kernel.org
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/hyperv/hvhdk_mini.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/hyperv/hvhdk_mini.h
+++ b/include/hyperv/hvhdk_mini.h
@@ -126,8 +126,9 @@ enum hv_dynamic_processor_feature_proper
 
 struct hv_input_get_system_property {
 	u32 property_id; /* enum hv_system_property */
+	u32 reserved;
 	union {
-		u32 as_uint32;
+		u64 as_uint64;
 #if IS_ENABLED(CONFIG_X86)
 		/* enum hv_dynamic_processor_feature_property */
 		u32 hv_processor_feature;


