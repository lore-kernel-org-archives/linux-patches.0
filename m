Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F6E3F65FF;
	Tue, 17 Mar 2026 17:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767082; cv=none; b=Q/PXsCdYHlicPn8UdiIH2olMn8hSMKphFUk2gWklUveWzRrmNS3fZ36BOTEBBbI5qkGMxCsQ3m8oisCd7/rRChJpS1P5bBXzQ7hw/1sYtuW6NZ424uc1LuuW5XUqCVK9yUjmK3cD9sifr74E/Fv8TGcLJd97eVoatZkhyLojyMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767082; c=relaxed/simple;
	bh=YxcNtAhpuN9Lv23PmQ3gFIAzi4KjG/+3UDt8BblmgmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOgpNa4M3Vhy8ng1uaDTg3FJhIxQ5uO10N9K7vp+HNVHD4yfTOxsyyYSZge2ENbVijHUaV5cajAqQlvG8oNdFlZpjoitYvsmL6Ofm4VBs26akistJeAGcPp9Ujjyq6Ah8W8DmV9ZrXkh9qb7JMzPJ1NUQTo5rev9cthHL4iecWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFDkZlvi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFDkZlvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269C8C4CEF7;
	Tue, 17 Mar 2026 17:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767082;
	bh=YxcNtAhpuN9Lv23PmQ3gFIAzi4KjG/+3UDt8BblmgmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFDkZlvi/mw0jIXtWBFgmWWbroKn/SO/cas47MbBioa4suNp2WOpKGS8ncQQVV8W5
	 l/SqdMevCRJqZu4Ne2tE58mtYQH9R9Kbde7lioNpivBKQ6VlBiW71+gJhBmHZ0frS0
	 /PRbWmEtJntSGd+XcgvAmX8uYxybofPEHeVPRdRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Azamat Almazbek uulu <almazbek1608@gmail.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 011/333] ASoC: amd: yc: Add ASUS EXPERTBOOK BM1503CDA to quirk table
Date: Tue, 17 Mar 2026 17:30:40 +0100
Message-ID: <20260317162959.778150313@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Azamat Almazbek uulu <almazbek1608@gmail.com>

[ Upstream commit 32fc4168fa56f6301d858c778a3d712774e9657e ]

The ASUS ExpertBook BM1503CDA (Ryzen 5 7535U, Barcelo-R) has an
internal DMIC connected through the AMD ACP (Audio CoProcessor)
but is missing from the DMI quirk table, so the acp6x machine
driver probe returns -ENODEV and no DMIC capture device is created.

Add the DMI entry so the internal microphone works out of the box.

Signed-off-by: Azamat Almazbek uulu <almazbek1608@gmail.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260221114813.5610-1-almazbek1608@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index f1a63475100d1..7af4daeb4c6ff 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -703,6 +703,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 				DMI_MATCH(DMI_PRODUCT_NAME, "Vivobook_ASUSLaptop M6501RR_M6501RR"),
 			}
 		},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ASUS EXPERTBOOK BM1503CDA"),
+		}
+	},
 	{}
 };
 
-- 
2.51.0



