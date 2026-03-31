Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93903A1E8C;
	Tue, 31 Mar 2026 16:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976243; cv=none; b=qThWx7YG0HDyrNHa0kksRYNKbmxLX4hBEvCDEZ1xyodmE0Wm5Tb3TF7WRrTwbAvTnA5J+uG/C1hqN3BVPOTlp3EELbZ12vmzZlHVExMjQqi1HvNlWADfuX7YlldYx62K+Q4lndORg8SKYbRg5DMVe65uzhskdnO7eJYRnUoU+Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976243; c=relaxed/simple;
	bh=Zu28t1U24FdTfEYgddS2nS3W+t8mrabxiWVgB5xQwYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lp9A5WJNSRu9MuUqsZnTrPH3/Bx7fwOkHnZlse+A4pi9msX4RYJxj1EVk2JY8spV28iCrljh51MRZ2VQrnjP8J+8Z68HhykoyUKISaSqUCM3e1LEmjmvqVShja2kJvq4r97dJGHVXZFHlvB4qu/4gjArcpX40mvEWeUGDQ3cmDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKnu+S6o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKnu+S6o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B7A5C19423;
	Tue, 31 Mar 2026 16:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976243;
	bh=Zu28t1U24FdTfEYgddS2nS3W+t8mrabxiWVgB5xQwYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKnu+S6oQJk/lYmNtZPRX5YGIXrrwStJ1T9Qdj+yWgA2T8hi5PMCXBRw5wqyASD0M
	 5EuPz6/O1s7V0nmpv98pYGa3MR7ncuIrgYRx1SxhXa33tVPEH3jS59lf953Wa+8rXU
	 bk1aPICSW6RNGnYVhdoEUVe28Zp+d5HQlJbCdwDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Noah Provenzano <noahpro@gmail.com>,
	Juan Martin Morales <juanm4morales@gmail.com>,
	Krishna Chomal <krishna.chomal108@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/309] platform/x86: hp-wmi: Add Omen 16-wf0xxx fan and thermal support
Date: Tue, 31 Mar 2026 18:18:41 +0200
Message-ID: <20260331161754.149061628@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Chomal <krishna.chomal108@gmail.com>

[ Upstream commit 13fa3aaf02edaad9b41fc61d7f6326d2b6a4bf80 ]

The HP Omen 16-wf0xxx (board ID: 8BAB) has the same WMI interface as
other Victus S boards, but requires quirks for correctly switching
thermal profile (similar to HP Omen 16-wf1xxx, board ID: 8C78).

Add the DMI board name to victus_s_thermal_profile_boards[] table and
map it to omen_v1_thermal_params.

Testing on HP Omen 16-wf0xxx confirmed that platform profile is
registered successfully and fan RPMs are readable and controllable.

Suggested-by: Noah Provenzano <noahpro@gmail.com>
Tested-by: Juan Martin Morales <juanm4morales@gmail.com>
Reported-by: Juan Martin Morales <juanm4morales@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220639
Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260216072003.90151-1-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index dfe45692c956a..244833fd785f3 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -154,6 +154,10 @@ static const char * const victus_thermal_profile_boards[] = {
 
 /* DMI Board names of Victus 16-r and Victus 16-s laptops */
 static const struct dmi_system_id victus_s_thermal_profile_boards[] __initconst = {
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BAB") },
+		.driver_data = (void *)&omen_v1_thermal_params,
+	},
 	{
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BBE") },
 		.driver_data = (void *)&victus_s_thermal_params,
-- 
2.51.0



