Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D383B20ADCA;
	Fri,  6 Dec 2024 15:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498107; cv=none; b=dtdpky1RciNqFZpKxBIU0fUUyMOGnfvKMcqL6SBGgBWHxbqlP/qaDi2l335QqbEZUIJmY+UpQoB/L67m+S0U0YYIrYYFgAxB5wy+UhD9dYAlI2442TPaslR67hYpa1ZinkqvN7QRo3NR197eFZuuqViveBFqCvSI/wbDYF+ph4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498107; c=relaxed/simple;
	bh=XdOkhAinEFUjG1SjrmP7QiKEUDO7Pp4KY9XFPCZ3p0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IywQ2B17CoIc4gkI7XMfRohtQKShJp3ICcgliEukxEwOKEm9LZWy75j+DvYq/V+xBr/NxhkL/cG4K1Zq2aD19l2l71E0gxvz7SydwJaYD2QOB44CevtASlhkO1o2hOOoyp1XSmpcbbphCxAoqVBeT1jA4DPqjzXsQ57yoJ7GqvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XexZ/1fK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XexZ/1fK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FCCC4CED1;
	Fri,  6 Dec 2024 15:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498107;
	bh=XdOkhAinEFUjG1SjrmP7QiKEUDO7Pp4KY9XFPCZ3p0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XexZ/1fKAgmIgK5cm7x9icAMihMrkkw7cEgSmi8u63jX4y3BuWxNibCJ3iPAVOpim
	 ta3NNbqq27hd/rNbPX1NkBhJtE7+c0IxFOIKOGxBoT/HTP4EOJOG9SqrgUcuiou5Nd
	 OpfHGkqtYsi9Qos69AWDI7lGPsM1iAbDr0EK8j8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.6 457/676] drm/amd/display: Add NULL check for function pointer in dcn20_set_output_transfer_func
Date: Fri,  6 Dec 2024 15:34:36 +0100
Message-ID: <20241206143711.220075238@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit 62ed6f0f198da04e884062264df308277628004f upstream.

This commit adds a null check for the set_output_gamma function pointer
in the dcn20_set_output_transfer_func function. Previously,
set_output_gamma was being checked for null at line 1030, but then it
was being dereferenced without any null check at line 1048. This could
potentially lead to a null pointer dereference error if set_output_gamma
is null.

To fix this, we now ensure that set_output_gamma is not null before
dereferencing it. We do this by adding a null check for set_output_gamma
before the call to set_output_gamma at line 1048.

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -880,7 +880,8 @@ bool dcn20_set_output_transfer_func(stru
 	/*
 	 * if above if is not executed then 'params' equal to 0 and set in bypass
 	 */
-	mpc->funcs->set_output_gamma(mpc, mpcc_id, params);
+	if (mpc->funcs->set_output_gamma)
+		mpc->funcs->set_output_gamma(mpc, mpcc_id, params);
 
 	return true;
 }


