Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E32018859F;
	Fri, 15 Nov 2024 06:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653555; cv=none; b=CSXIAUHF4FXt5FeDUGw9FfAhqmg22UCH+zVxbJrJX7MxgRxV+hDDdrjHR4w/JFrsiF7YAC2QdUeQVEaRDgsI7Iyqq0WpXLpCOJNLJKF2zvUuyuCaC3V3zg6dF2lBIfIcWN6EviM6N261QAl3mTNbjnhOqza7UfQ9LtA967fCbAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653555; c=relaxed/simple;
	bh=FmdVXfSG2kAG1PW9cJ1C7oIxiVpgrmmrIzCEfDdpy+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qynHNiepeWb4985PYgVTCsJzOSvHkiH77udmRNXbPBb0NcdOKTcQSyvpzjvDq1Q0zZXTZNU0cfvk5JtP9iVAWslN938PFIChF8ZWId9uYliorJ4NoowknUcrph37Rh46dtb5sssilb2imjIs0eTeGFoQBI+f6ddNGQ4jFizGuPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IgsK3j8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IgsK3j8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E391C4CECF;
	Fri, 15 Nov 2024 06:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653554;
	bh=FmdVXfSG2kAG1PW9cJ1C7oIxiVpgrmmrIzCEfDdpy+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IgsK3j8/A5lHTt3f3cGg/1/boL4UiXuMdlXH5DvbKuTaDbG+1slrX3vtFhWJVMG7B
	 jWQqSTaYEXBbcz2QAlIN6a/t2sIHu1tQfDsn0aggf7jrAJOWyJQlWdL5tPBMDDzF+l
	 fTKuxICwXqy5pmbmnSplaD50M+z3qREqF+s8kHkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dudikov <ilyadud@mail.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 30/48] ASoC: amd: yc: Fix non-functional mic on ASUS E1404FA
Date: Fri, 15 Nov 2024 07:38:19 +0100
Message-ID: <20241115063724.051791195@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

From: Ilya Dudikov <ilyadud@mail.ru>

[ Upstream commit b0867999e3282378a0b26a7ad200233044d31eca ]

ASUS Vivobook E1404FA needs a quirks-table entry for the internal microphone to function properly.

Signed-off-by: Ilya Dudikov <ilyadud@mail.ru>
Link: https://patch.msgid.link/20241016034038.13481-1-ilyadud25@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 2d766d988eb2e..08f823cd88699 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -325,6 +325,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "M6500RC"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E1404FA"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



