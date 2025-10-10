Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40482F3605;
	Fri, 10 Oct 2025 13:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102325; cv=none; b=HfkBIWlZnEIpTSxBe8ihIpCxBs1PvOSOWJQqU/6tkt0Euffd5riMKfLLyZOsOY+iQwxhUbkl/8flF+LQCdOQqBHiA/0UPrvc74igO6WYfvnxe/+WOJp/xyBUKVMr8NwapPFVNSmEiGcFcoLXnG9GMCu5mDgfjT8SbDvfIpflPWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102325; c=relaxed/simple;
	bh=CHjjLywlQfdqxYcXQr9XisUZhNPPceFzd0hKGGiWxWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NAZC7woz/kWHGbNpdZP2A3g1Kga6gb2RRLwEQo3y1SUgwveGP/SqEGQXrNKaHy5VWhMz8Jyryxgu4f1MVi4tYDJfrz7OoecybR2VMILA3N3wkWShxfvfAx82UiSa912TUg5cm0bSQVfxhCeX+MdbOn3dp8aLjZIUyR0mluWigX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f08bqwf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f08bqwf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800B8C4CEF1;
	Fri, 10 Oct 2025 13:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102324;
	bh=CHjjLywlQfdqxYcXQr9XisUZhNPPceFzd0hKGGiWxWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f08bqwf/tsTB8GJK9kUvjzSROF/j+C29kGNumCAI4DTrColeeSb5kiNOas8Kbix2c
	 tSgqHKjd52lreetwPBiRJo+gsDY9UIAZxsv9Dt6Z8sTN8sL1n7TWdYaMZxPCdE4aPT
	 pRMzzTnFJZNcaKuIXzDB7ufUWR+huWGHFtZEo3Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 17/41] platform/x86: oxpec: Add support for OneXPlayer X1Pro EVA-02
Date: Fri, 10 Oct 2025 15:16:05 +0200
Message-ID: <20251010131334.046872106@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit fba9d5448bd45b0ff7199c47023e9308ea4f1730 ]

It is a special edition of X1Pro with a different color.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20250904132252.3041613-1-lkml@antheas.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/oxpec.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/platform/x86/oxpec.c b/drivers/platform/x86/oxpec.c
index eb076bb4099be..4f540a9932fe1 100644
--- a/drivers/platform/x86/oxpec.c
+++ b/drivers/platform/x86/oxpec.c
@@ -306,6 +306,13 @@ static const struct dmi_system_id dmi_table[] = {
 		},
 		.driver_data = (void *)oxp_x1,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ONE-NETBOOK"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "ONEXPLAYER X1Pro EVA-02"),
+		},
+		.driver_data = (void *)oxp_x1,
+	},
 	{},
 };
 
-- 
2.51.0



