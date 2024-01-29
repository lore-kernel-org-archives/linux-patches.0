Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822D215A48F;
	Mon, 29 Jan 2024 17:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548270; cv=none; b=kLGQuVup78jqSw0RNfkFYZEQ5K0Hy70uUc73yiD/rXZrV4hzYN7Q34+q1wSJSRgCtjBeThvvoE8V1iao1yd06PXTjz/kQZf4gMyBWhdGIZ/kDh0mc+SMrrf/U7X6fnwKE89tYRQC5f+dzxkvsF5GW9nGYSAYCKBJYElajbjBiNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548270; c=relaxed/simple;
	bh=URA//+x52o8H9Rdh0TE4Cqiqc63N7fuT9HFjT0dgG2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUw/4jH2ovc1pRxYAnHHUxzCeze4y5lPuae8GHkc2b2sZex0ynrVawyIWqTc5wOkdLDXM7/tHSrrnv7cosR9/C/bCNt/z5gleJZGM125yIU+9Blp3NDTKYSbqKLNcjKL4ONU9FNPCN26Bfh5D35zF9OneYsrE3BfNd2w+TbE3jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A++Oe6V9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A++Oe6V9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F44C433C7;
	Mon, 29 Jan 2024 17:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548270;
	bh=URA//+x52o8H9Rdh0TE4Cqiqc63N7fuT9HFjT0dgG2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A++Oe6V9oKFusvS51MSEopoPsy8ks4QgZVQKJ++Nxw1YAKOwevSKUSaO26sgJpc0t
	 e/ReN2ehox6QGgGI4nb7FJVkgVdVXoLzc/zQ8+QtorTIcvqsHX06BdpDKFmpMVJ7fL
	 UuPvzBaso4pY9zJUjXnjrtkTOzIG2v3yLCOqTrHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	aaron.ma@canonical.com,
	binli@gnome.org,
	Marc Rossi <Marc.Rossi@amd.com>,
	Hamza Mahfooz <Hamza.Mahfooz@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harry Wentland <harry.wentland@amd.com>
Subject: [PATCH 6.7 257/346] drm/amd/display: Disable PSR-SU on Parade 0803 TCON again
Date: Mon, 29 Jan 2024 09:04:48 -0800
Message-ID: <20240129170023.957212553@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 571c2fa26aa654946447c282a09d40a56c7ff128 upstream.

When screen brightness is rapidly changed and PSR-SU is enabled the
display hangs on panels with this TCON even on the latest DCN 3.1.4
microcode (0x8002a81 at this time).

This was disabled previously as commit 072030b17830 ("drm/amd: Disable
PSR-SU on Parade 0803 TCON") but reverted as commit 1e66a17ce546 ("Revert
"drm/amd: Disable PSR-SU on Parade 0803 TCON"") in favor of testing for
a new enough microcode (commit cd2e31a9ab93 ("drm/amd/display: Set minimum
requirement for using PSR-SU on Phoenix")).

As hangs are still happening specifically with this TCON, disable PSR-SU
again for it until it can be root caused.

Cc: stable@vger.kernel.org
Cc: aaron.ma@canonical.com
Cc: binli@gnome.org
Cc: Marc Rossi <Marc.Rossi@amd.com>
Cc: Hamza Mahfooz <Hamza.Mahfooz@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2046131
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/power/power_helpers.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
+++ b/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
@@ -841,6 +841,8 @@ bool is_psr_su_specific_panel(struct dc_
 				isPSRSUSupported = false;
 			else if (dpcd_caps->sink_dev_id_str[1] == 0x08 && dpcd_caps->sink_dev_id_str[0] == 0x03)
 				isPSRSUSupported = false;
+			else if (dpcd_caps->sink_dev_id_str[1] == 0x08 && dpcd_caps->sink_dev_id_str[0] == 0x03)
+				isPSRSUSupported = false;
 			else if (dpcd_caps->psr_info.force_psrsu_cap == 0x1)
 				isPSRSUSupported = true;
 		}


