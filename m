Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394E2303A28;
	Wed,  3 Dec 2025 16:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777939; cv=none; b=TRT6xluAVRHyysq1RBMDSh6p7HNezvfekR7b+cmgD91xOstwtLlQU3ug3e4+CO4YU1B+o77ZQbs0ORJb4QyaIYuoBaeWgYOaNSKdWv6Lt3sRsZAtPR5oit1wXn8hTIgDB+5TL3/j65epk1a6T2FhG5uIhz/jCMa65UEGws8lNpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777939; c=relaxed/simple;
	bh=qZD58kq94FllfbhU87Bsbg+JtxX9Iby9XEhSFvOdPS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEDtB9wPKe9duccAMiKT/080A6TT0zY66ZFZOccpY4zZJKvvEeW1nVKR2BBhWgIbH8jJdw2kxnddspL/gLZdaOsYOfLINTIYql8ELQ2ws4Q9UzSYRr410sndqbh2zIFm5VFA8vYS55mB8CXDNZKsj+7pRLNlzMgVKDwG2PK/ZAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x79lP6xC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x79lP6xC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CD3C116B1;
	Wed,  3 Dec 2025 16:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777939;
	bh=qZD58kq94FllfbhU87Bsbg+JtxX9Iby9XEhSFvOdPS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x79lP6xCYu4eYyAnpBnwPDPc0W9umBRCn2zv2V2Ui50jkxlSiHPH+5TateFXHItvu
	 PbpZ5pu9rLJgFXMI8RsY7EWcP0+Wx6cc54GTa/QQnWA2LtvNUf3XhutiKGDOO5txYi
	 0ZT7MrMKQI3zRW0ff8drfmkP6Qiocu8zjVZ7kaUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 193/392] um: Fix help message for ssl-non-raw
Date: Wed,  3 Dec 2025 16:25:43 +0100
Message-ID: <20251203152421.176972773@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 725e9d81868fcedaeef775948e699955b01631ae ]

Add the missing option name in the help message. Additionally,
switch to __uml_help(), because this is a global option rather
than a per-channel option.

Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/ssl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index 8514966778d53..1bb657a296906 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -199,4 +199,7 @@ static int ssl_non_raw_setup(char *str)
 	return 1;
 }
 __setup("ssl-non-raw", ssl_non_raw_setup);
-__channel_help(ssl_non_raw_setup, "set serial lines to non-raw mode");
+__uml_help(ssl_non_raw_setup,
+"ssl-non-raw\n"
+"    Set serial lines to non-raw mode.\n\n"
+);
-- 
2.51.0



