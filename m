Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05521423A8A;
	Tue, 31 Mar 2026 16:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976303; cv=none; b=hG7LtaCm6fwEbqQ/qAsAe1TbI2xmH5edgaYoyNPpUCCslbO0gwetd14HN1+FA4+OmKJy0db9PZeW/EE9XtbdVF4d5as2ZSDbk4E0vGcyGW/wkRZfvJJkRJYHkQ6TosenwRnRlDGQm+eDUfdAeGpmnFT4aCwjI1bVTsUokV+HRvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976303; c=relaxed/simple;
	bh=CSGLP4U20vWPQvEiahAuSm2K5PWE8mK1sH9q9YkXlvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kPqH2prs6k+x75bzBwEKNhfzExE7bsyNvfoHdQAdhBcPwXuFEeaV2unYHEGIsWbvZy6Nv1SahMeOBbO2F5W7kfEIW8jhH0D8G6JDBjOBbCUzHNxjPjXADM+YzrNrBo544+0283vuL0lu0gJawU/wcANk5cUxZr0S2HdhUeoQ50o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZdZF9fo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZdZF9fo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DEB5C19423;
	Tue, 31 Mar 2026 16:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976302;
	bh=CSGLP4U20vWPQvEiahAuSm2K5PWE8mK1sH9q9YkXlvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZdZF9forOUQj2Lok3Fd1vZXaDC8C4y5wmRjOAEnKBJJOOuzJagencxgAL/Q6iO7d
	 UP5mRZRO223yjD8Ow517Jpf9l9Leu6tQhv+uH0rqca/kHmAl+28LxkBHEKOY92re2M
	 jBapUnUxIYvQGb1+opZG1lsHvvQYsutJw3aYnASo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varad Amol Pisale <varadpisale.work@gmail.com>,
	Krishna Chomal <krishna.chomal108@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 023/309] platform/x86: hp-wmi: Add Omen 16-xd0xxx fan and thermal support
Date: Tue, 31 Mar 2026 18:18:46 +0200
Message-ID: <20260331161754.332687739@linuxfoundation.org>
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

[ Upstream commit 3c99a545b372c77b5d39715968a141f523eccbf2 ]

The HP Omen 16-xd0xxx (board ID: 8BCD) has the same WMI interface as
other Victus S boards, but requires quirks for correctly switching
thermal profile (similar to HP Omen 16-wf1xxx, board ID: 8C78).

Add the DMI board name to victus_s_thermal_profile_boards[] table and
map it to omen_v1_thermal_params.

Testing on HP Omen 16-xd0xxx confirmed that platform profile is
registered successfully and fan RPMs are readable and controllable.

Tested-by: Varad Amol Pisale <varadpisale.work@gmail.com>
Signed-off-by: Krishna Chomal <krishna.chomal108@gmail.com>
Link: https://patch.msgid.link/20260218050235.94687-1-krishna.chomal108@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 244833fd785f3..008f3364230e2 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -162,6 +162,10 @@ static const struct dmi_system_id victus_s_thermal_profile_boards[] __initconst
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BBE") },
 		.driver_data = (void *)&victus_s_thermal_params,
 	},
+	{
+		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BCD") },
+		.driver_data = (void *)&omen_v1_thermal_params,
+	},
 	{
 		.matches = { DMI_MATCH(DMI_BOARD_NAME, "8BD4") },
 		.driver_data = (void *)&victus_s_thermal_params,
-- 
2.51.0



