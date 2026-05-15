Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0233B1029;
	Fri, 15 May 2026 16:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862723; cv=none; b=UH2rXMJlY0FNLnpCrRUHwNbFwja3y2U03GIcbUQBipZuETTmpzY3HDXwSSApLpzQJoRIAdtVfipjGaZLtl2ljqnL47dnU/zMXAc0BRv/0BfUmje+PDVx7UCbTEkqtUAecXnWYsqGc25jHQKbJd6ZMC0m5kxJ07hFAAF76I02iOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862723; c=relaxed/simple;
	bh=Yllzd1fTkyHMOyrJfQVMuf86EC+okVhueJUngIWc2iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lmb4N5Q+tNz918QOri8C9XyNotHmY+96pUNuusXNMmlejJK2TKHB724E6h4P+wLB9Prc0Pp+9UFO5CssqaEXbKAcLjEKhn8IpiOxEoW+jkYTYa6MaDGwBZtOn+PNYRDex4csu4JSW0zC+UszdBkPL4SkD1d/RFcNuLoyUPy8shc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzVhleiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzVhleiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F41C2BCB0;
	Fri, 15 May 2026 16:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862723;
	bh=Yllzd1fTkyHMOyrJfQVMuf86EC+okVhueJUngIWc2iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZzVhleiI6xX1vndUeDEjr1LxWLzd/bNH9H9sCN/vW/aGbAq7AU/hsZupaKsYvxe7G
	 ap7i4DvnyhMmBsHBGN/9mpS5h8OG2e5ae6iUpSSVtX0mF9JIFzC+Vku3nLduzj6z2X
	 jmqasFZbr1wSP9bWbtNRmVy/T+d+FQnony6eDlJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 7.0 131/201] drm/amd/display: fix math_mod() using arg1 instead of arg2
Date: Fri, 15 May 2026 17:49:09 +0200
Message-ID: <20260515154701.404450024@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjing Liu <wenjing.liu@amd.com>

commit 2b104fc31be0607c04188fadbd4a9fa5b50f3b99 upstream.

[Why]
math_mod() multiplied by arg1 instead of arg2, returning a wrong
result for any non-trivial modulo operation.

[How]
Replace arg1 with arg2 in the subtraction term to correctly
implement fmod(arg1, arg2).

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_standalone_libraries/lib_float_math.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_standalone_libraries/lib_float_math.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_standalone_libraries/lib_float_math.c
@@ -23,7 +23,7 @@ double math_mod(const double arg1, const
 		return arg2;
 	if (isNaN(arg2))
 		return arg1;
-	return arg1 - arg1 * ((int)(arg1 / arg2));
+	return arg1 - arg2 * ((int)(arg1 / arg2));
 }
 
 double math_min2(const double arg1, const double arg2)


