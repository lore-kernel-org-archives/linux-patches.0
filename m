Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9421F26E3;
	Tue, 12 Nov 2024 10:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407078; cv=none; b=iVEDvQItspa/R+agSba2sKKxxCGvECGS2db1Ff75NEzN7+0jYVO6DIexTfi2GAsITC3/S9uvfssbflRYqZiTL2u1ARPSpc5yZgaW3XkdsTy2llQ8UrIdjtMqNKWoS7x9uHAA1ve35sAGb1pQ2asfyd0KtoWRYcaTPN1bCgcrHGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407078; c=relaxed/simple;
	bh=Iv4r7q2/4gDf4Uhzd27nyZHTAXc8ZodAbrK/+kR1bqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnZ3/9MlUOC0EyMJb8rgBVFH46ITzzIr2A/rmHLfofjk1iQXfQZHTM6d25jpEG6ORatTtK3EUFcGeLh/HC6Ipcsp1WKs/JZq4dxkQMshSuBJKLYftcEi2Jyqo3gj9sh5Wo1XTir8wOeXfJrc61VW48KGw4bdkHY8HOkXGB+2W0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fI5jokoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fI5jokoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56357C4CECD;
	Tue, 12 Nov 2024 10:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407077;
	bh=Iv4r7q2/4gDf4Uhzd27nyZHTAXc8ZodAbrK/+kR1bqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fI5jokoLKdsihmMlUPJWHIeCxdPRHL8kXPmJj89Hs1MAnb6uyzKh0xi43ALxtUa+E
	 gOKZU94ML8Nrna6GhJyqq7RG7/3v+tYkOphomMDZYLZGJ/n2W5CZvX5k7XDUi7+CUh
	 JrnoZVYF1j8x7C0TTaIsc+F1ksHwx+ZyE++VGyEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 26/76] media: stb0899_algo: initialize cfr before using it
Date: Tue, 12 Nov 2024 11:20:51 +0100
Message-ID: <20241112101840.783922955@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

commit 2d861977e7314f00bf27d0db17c11ff5e85e609a upstream.

The loop at stb0899_search_carrier() starts with a random
value for cfr, as reported by Coverity.

Initialize it to zero, just like stb0899_dvbs_algo() to ensure
that carrier search won't bail out.

Fixes: 8bd135bab91f ("V4L/DVB (9375): Add STB0899 support")
Cc: stable@vger.kernel.org
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/dvb-frontends/stb0899_algo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb-frontends/stb0899_algo.c
+++ b/drivers/media/dvb-frontends/stb0899_algo.c
@@ -269,7 +269,7 @@ static enum stb0899_status stb0899_searc
 
 	short int derot_freq = 0, last_derot_freq = 0, derot_limit, next_loop = 3;
 	int index = 0;
-	u8 cfr[2];
+	u8 cfr[2] = {0};
 	u8 reg;
 
 	internal->status = NOCARRIER;


