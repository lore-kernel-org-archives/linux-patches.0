Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EF318C03D;
	Mon, 28 Oct 2024 06:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097434; cv=none; b=NfSAuGnkrKfBsMZyYVSUPNdZclCxG1q6OmnWvK9bDXYsxfIGduhtqkaDwxwcDebujUplYIewduNtdtQGaMyd4cphGM33PYbssoa1DzbvxQIVwNqdRQNSeKJHVr+AkW9xjI79poQqsgJ/YAIpLu4oJroZgCKXcuIKr2kELSId7B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097434; c=relaxed/simple;
	bh=Wv0Mnb8r9igyGWwlwzJk8yWyuRY+vT2A3UvW1mXsYao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flE+YqqkWr0MKT1TYR8ev4zoiz0Pkpe3MjexbfZVuoRg5Mm+iuWqD7+KWrG7LHGsIdeeaHQE0kUyTrK7tCP1mxNDkfG6K7ihk8W6Y7xjdPTPiaHqTVXaSaWCo5e0aq9ApYx1joNPSaeSTskXXtyYCuVIggGvLvHjmY8/glcwMrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YIYdpSba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YIYdpSba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F07C4CEC3;
	Mon, 28 Oct 2024 06:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097433;
	bh=Wv0Mnb8r9igyGWwlwzJk8yWyuRY+vT2A3UvW1mXsYao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIYdpSbaXwN8qq52v/XGhALOVeCHjU1QNDWHl1RzzthL8z+FVB0u21TNC03NLhtBC
	 vvdhTlN5Ig7nyILA1oPXl5dE8RFE2l+6Zkx0RkpwKPvueLrwJuGJEYXzXzQEu+DLwF
	 vm33dSfSYhZlSTkM5/UPNxTqcl3lG4aOeT2UkJe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Rossi <Marc.Rossi@amd.com>,
	Hamza Mahfooz <Hamza.Mahfooz@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 129/137] drm/amd/display: Disable PSR-SU on Parade 08-01 TCON too
Date: Mon, 28 Oct 2024 07:26:06 +0100
Message-ID: <20241028062302.306589299@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit ba1959f71117b27f3099ee789e0815360b4081dd upstream.

Stuart Hayhurst has found that both at bootup and fullscreen VA-API video
is leading to black screens for around 1 second and kernel WARNING [1] traces
when calling dmub_psr_enable() with Parade 08-01 TCON.

These symptoms all go away with PSR-SU disabled for this TCON, so disable
it for now while DMUB traces [2] from the failure can be analyzed and the failure
state properly root caused.

Cc: Marc Rossi <Marc.Rossi@amd.com>
Cc: Hamza Mahfooz <Hamza.Mahfooz@amd.com>
Link: https://gitlab.freedesktop.org/drm/amd/uploads/a832dd515b571ee171b3e3b566e99a13/dmesg.log [1]
Link: https://gitlab.freedesktop.org/drm/amd/uploads/8f13ff3b00963c833e23e68aa8116959/output.log [2]
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/2645
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Link: https://lore.kernel.org/r/20240205211233.2601-1-mario.limonciello@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit afb634a6823d8d9db23c5fb04f79c5549349628b)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/power/power_helpers.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
+++ b/drivers/gpu/drm/amd/display/modules/power/power_helpers.c
@@ -818,6 +818,8 @@ bool is_psr_su_specific_panel(struct dc_
 				isPSRSUSupported = false;
 			else if (dpcd_caps->sink_dev_id_str[1] == 0x08 && dpcd_caps->sink_dev_id_str[0] == 0x03)
 				isPSRSUSupported = false;
+			else if (dpcd_caps->sink_dev_id_str[1] == 0x08 && dpcd_caps->sink_dev_id_str[0] == 0x01)
+				isPSRSUSupported = false;
 			else if (dpcd_caps->psr_info.force_psrsu_cap == 0x1)
 				isPSRSUSupported = true;
 		}


