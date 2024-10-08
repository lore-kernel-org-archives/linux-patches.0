Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F0D183CB8;
	Tue,  8 Oct 2024 12:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391871; cv=none; b=gyEpVCHvSG1Kggt54/lWetX7Q26JKquMeL7dMdjmX/pB+vyR9aCpPXeE4Ef9ULPacTOnORXnlDuf6ToZ5Fzv+JfkWl0fXp/rL+EDsr2adKRgCEykKJmVB4v5fXUbIXU0Z49X5HohFOTGQmDiMAmAfp1U9RtRZ/RbigsriORbUfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391871; c=relaxed/simple;
	bh=euSTtZweBmcSn0C+P6u67na3g1XAFo/YSfWS7KUB1Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbVhFGc9V0H+G/p15TvRWzBwfRrfiFnfrbKBXZYRhQB9dqHS3nNg5GRhgYY451L8WR8YfoMDVTYuXUlgPJGpyAEnPwcxVG1zhf1NJSgDL7mbVGl+3H0gAWkx1cpR+2XifqdJQe9w7DJnRdNG8OEBnJQCqKUuw8ji1YEGCRDI70Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFmQ+APe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFmQ+APe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E8CC4CEC7;
	Tue,  8 Oct 2024 12:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391871;
	bh=euSTtZweBmcSn0C+P6u67na3g1XAFo/YSfWS7KUB1Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFmQ+APew+XweLCQRkVCHH4ofq0MDSG2/5dM8qZ+yoKyqLoWDZZPYLUkM0NB0tCFO
	 LFLmxKZFn9LlsroaxmxV5MK+GZS03XrRhiSOkYcZCUGWESVX24Ct4SDJ6FL864PyZK
	 sOpqCDU3QsXk3NRr/SgP3frDDIBVFIIKCM6oN2Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	aln8 <aln8un@gmail.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 248/558] platform/x86/amd: pmf: Add quirk for TUF Gaming A14
Date: Tue,  8 Oct 2024 14:04:38 +0200
Message-ID: <20241008115712.098339234@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: aln8 <aln8un@gmail.com>

[ Upstream commit 06369503d644068abd9e90918c6611274d94c126 ]

The ASUS TUF Gaming A14 has the same issue as the ROG Zephyrus G14
where it advertises SPS support but doesn't use it.

Signed-off-by: aln8 <aln8un@gmail.com>
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20240912073601.65656-1-aln8un@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/pmf-quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/platform/x86/amd/pmf/pmf-quirks.c b/drivers/platform/x86/amd/pmf/pmf-quirks.c
index 48870ca52b413..7cde5733b9cac 100644
--- a/drivers/platform/x86/amd/pmf/pmf-quirks.c
+++ b/drivers/platform/x86/amd/pmf/pmf-quirks.c
@@ -37,6 +37,14 @@ static const struct dmi_system_id fwbug_list[] = {
 		},
 		.driver_data = &quirk_no_sps_bug,
 	},
+	{
+		.ident = "ASUS TUF Gaming A14",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "FA401W"),
+		},
+		.driver_data = &quirk_no_sps_bug,
+	},
 	{}
 };
 
-- 
2.43.0



