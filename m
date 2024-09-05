Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F871494DB;
	Thu,  5 Sep 2024 10:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530449; cv=none; b=p3loy4Z075+m8WduKAbfQgE05C+Zpis80wl8denFVhh8xJ0XyuMDMIoxK6noE8I5DLMByJkyEy+CzoEU1aZBPkG1i7RsFLXncWbu7Of5KeDinufRLr6J6i5vYsRnEovXdh5x1VFp9wMO3AJqotku+mP7Z6QSR5uDoToNyvo6f+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530449; c=relaxed/simple;
	bh=lnW1smJhF4zoNkTuVQYgHmlAIKrQ33W52f9I3PnZpR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gu8i7/zmGSrpArg5pG2KtMyZCGJ9h9iVa4THax6Fiy/drNUfAqRLI8mFYDGU4vfhoc8BvjCu205RBHhJINsqmrFGQZJBanXqvrHkKeWNuXFS9ef5fthrvMZAUImD50v0i7kV7wcPJ5uhXFf67ldViewJlLAlmaxE0z0NMcSAPLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t2s9Y9q8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t2s9Y9q8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A095C4CEC3;
	Thu,  5 Sep 2024 10:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530449;
	bh=lnW1smJhF4zoNkTuVQYgHmlAIKrQ33W52f9I3PnZpR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2s9Y9q8xbsOr5ACNPLDJH1jmh27MiEx6449/l4t5XTCPRKV/l8sOEWtqM8EcTv9Q
	 XKBzXcel+dODtk3fARTcCKz8axgqqVleBCg0NiMXS9Qvojw4mctYW8zvrb8hNXxDFE
	 1sM1KIISjDAOcJ3cQbBl65yG7+uM8hymBXChvP5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20St=C4=99pniak?= <kfs.szk@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/101] ASoC: amd: yc: Support mic on Lenovo Thinkpad E14 Gen 6
Date: Thu,  5 Sep 2024 11:40:40 +0200
Message-ID: <20240905093716.413883256@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Stępniak <kfs.szk@gmail.com>

[ Upstream commit 23a58b782f864951485d7a0018549729e007cb43 ]

Lenovo Thinkpad E14 Gen 6 (model type 21M3)
needs a quirk entry for internal mic to work.

Signed-off-by: Krzysztof Stępniak <kfs.szk@gmail.com>
Link: https://patch.msgid.link/20240807001219.1147-1-kfs.szk@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index b4a40a880035c..de655f687dd7d 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -220,6 +220,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "21J6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21M3"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.43.0



