Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56DD622A4F4;
	Tue, 29 Apr 2025 17:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947606; cv=none; b=JBP2JUGo8bplIUUprBkzwJ7Qz+S93rmx0cBdPZwUTQh+TbucHUZ2JydRkuiww59vEB3tpW+iT/oybrr5EpowhOv4Fbpy744Ny1vYvE/QnyAmBitkC7FR6HezVENi6ndGzrRTLg4cEYH0guBkEc0fEZfA0WXEd5lT0DLDDLu49rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947606; c=relaxed/simple;
	bh=CLnWPPYSUL6dFFQ6sg3sF6AN00NDx5ZcIxnkBnjMHxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2Gl9k79GVbVjqgkGSdSkpLtZXWONCI0Yt5di6+Whmenp1c8e1/bmM1+iY7G0CuvXPz6m5ua1xF84BVyjdbWbeXg2FVxZOFgRx4aVRU6xuHp/2N/WchRY6nxXcTZ7DyZdGeILBGnRQViqkTCFyVFHsAQx7vLcEEKzfpkGOcauDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWC7OqHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWC7OqHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5267AC4CEE3;
	Tue, 29 Apr 2025 17:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947605;
	bh=CLnWPPYSUL6dFFQ6sg3sF6AN00NDx5ZcIxnkBnjMHxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWC7OqHeW03CV7X6oqz5amJPzzHOtcay6Rtii6iGRm8FoABvy2uCDz6DCLoHolZbv
	 I9s76JVUaUbmI+opHbCLCbYsgj9ShG1OjxXGsATT9SWeC7T+Iy2DwBaU3aKsAqdn6n
	 J6y0iJFP82AjPytgibRjFonJoxXcy9IPHyIfjxl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/280] lib/Kconfig.ubsan: Remove default UBSAN from UBSAN_INTEGER_WRAP
Date: Tue, 29 Apr 2025 18:39:50 +0200
Message-ID: <20250429161117.133091457@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit cdc2e1d9d929d7f7009b3a5edca52388a2b0891f upstream.

CONFIG_UBSAN_INTEGER_WRAP is 'default UBSAN', which is problematic for a
couple of reasons.

The first is that this sanitizer is under active development on the
compiler side to come up with a solution that is maintainable on the
compiler side and usable on the kernel side. As a result of this, there
are many warnings when the sanitizer is enabled that have no clear path
to resolution yet but users may see them and report them in the meantime.

The second is that this option was renamed from
CONFIG_UBSAN_SIGNED_WRAP, meaning that if a configuration has
CONFIG_UBSAN=y but CONFIG_UBSAN_SIGNED_WRAP=n and it is upgraded via
olddefconfig (common in non-interactive scenarios such as CI),
CONFIG_UBSAN_INTEGER_WRAP will be silently enabled again.

Remove 'default UBSAN' from CONFIG_UBSAN_INTEGER_WRAP until it is ready
for regular usage and testing from a broader community than the folks
actively working on the feature.

Cc: stable@vger.kernel.org
Fixes: 557f8c582a9b ("ubsan: Reintroduce signed overflow sanitizer")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20250414-drop-default-ubsan-integer-wrap-v1-1-392522551d6b@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
[nathan: Fix conflict due to lack of rename from ed2b548f1017 in stable]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/Kconfig.ubsan | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index 1d4aa7a83b3a5..37655f58b8554 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -118,7 +118,6 @@ config UBSAN_UNREACHABLE
 
 config UBSAN_SIGNED_WRAP
 	bool "Perform checking for signed arithmetic wrap-around"
-	default UBSAN
 	depends on !COMPILE_TEST
 	# The no_sanitize attribute was introduced in GCC with version 8.
 	depends on !CC_IS_GCC || GCC_VERSION >= 80000
-- 
2.39.5



