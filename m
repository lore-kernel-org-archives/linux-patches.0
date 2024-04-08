Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650FE7E58C;
	Mon,  8 Apr 2024 13:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584086; cv=none; b=rBJTpq+0uwEuwUW2supFiajCcxa49pclBaj1DmJd5ol1PRXY+WbEfXYoZ6qAq3C9Yj0/feqIGcerlOOJ9uB/oPEvs9owjnsJdP4OXsTY/ApoGne6zFVFLTA6IWOuSHKD09doKBU+/UdxKbZrc5SrJMAcxcXl2LVYbj2u1PnKo24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584086; c=relaxed/simple;
	bh=rauFtehWqLZoqEdDqUdC2UKgTPP8Pu145aamOUWV+GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kv3MG8i39ViNsh3EF2GPBgR2N4B5Knj4Bsh4bvIpInYQvdStzcBJBhc8cL6x/NVwWtYFGOnEOmtFNpPKvZ860d5QqG/le/Nx1AqkPvQIQIPJ0HeO1XxvavNJNqvDRTnV5smrYRL2ynMnVrL3EyaLVT+rtGOY8tVGLc8ajOmmolQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWdHhCyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWdHhCyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5987C433F1;
	Mon,  8 Apr 2024 13:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584086;
	bh=rauFtehWqLZoqEdDqUdC2UKgTPP8Pu145aamOUWV+GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWdHhCyJhj6iVe3+fHEHTMeyGrvFQ/Me3BcVd8ckjlr3XwgbrFM9+pvEd/Xca6wpX
	 HuI6XZnwy2CeMnR8KtX62Xs8BCdt6LBVI02kUfJUeAS9N8VN/VfLAJwfVacdAYXSJW
	 /N+2VXwTCVe9TPL0AjFfksuZgawrd2IXTgL2hAwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uma Shankar <uma.shankar@intel.com>,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.8 259/273] drm/i915/mst: Reject FEC+MST on ICL
Date: Mon,  8 Apr 2024 14:58:54 +0200
Message-ID: <20240408125317.516841711@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 99f855082f228cdcecd6ab768d3b8b505e0eb028 upstream.

ICL supposedly doesn't support FEC on MST. Reject it.

Cc: stable@vger.kernel.org
Fixes: d51f25eb479a ("drm/i915: Add DSC support to MST path")
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240402135148.23011-7-ville.syrjala@linux.intel.com
(cherry picked from commit b648ce2a28ba83c4fa67c61fcc5983e15e9d4afb)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -1422,7 +1422,8 @@ static bool intel_dp_source_supports_fec
 	if (DISPLAY_VER(dev_priv) >= 12)
 		return true;
 
-	if (DISPLAY_VER(dev_priv) == 11 && encoder->port != PORT_A)
+	if (DISPLAY_VER(dev_priv) == 11 && encoder->port != PORT_A &&
+	    !intel_crtc_has_type(pipe_config, INTEL_OUTPUT_DP_MST))
 		return true;
 
 	return false;


