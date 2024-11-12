Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCA1218D69;
	Tue, 12 Nov 2024 10:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408222; cv=none; b=sfE0/7IEVQPgaMlNCOHXyeYWJnCby8erqPMMJTu2JDI4P2DsFqA0I9XxBtoSuL0pPOuPO9O2JYMpRL3Vf4lq8WSa511XKA2oXkzG0A+lvPXYdzdgl0RaEP2of+TZ+fyKxhgHk01h/1S4GpSJzlsFftOlevNO6fXogx3aRfA40P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408222; c=relaxed/simple;
	bh=T1chZ4q/1P0kTuxO+L/4NNAYkpO0nF3OKsFmVtbUZEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irVgS1IVspyGmxT86N6N7m2USgMMSK736ns3V1De7Q8hc9MOm+i3k/yDOoS2LXd+2dMJCpLC9Bs7jF99WeU46gc4/Y/I2cbmvOKXyPCfYF5AYeLxT4p6955jiW+1GEa5JlhdqfFLlqT1s2YekKbyatK1YWzOg1pjD+oVnd1a23Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wh1PQcQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wh1PQcQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2AEC4CECD;
	Tue, 12 Nov 2024 10:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408222;
	bh=T1chZ4q/1P0kTuxO+L/4NNAYkpO0nF3OKsFmVtbUZEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wh1PQcQnDzPEL52OabOq/pQPAC9zxfdUJ/OwUcf5eLB5O8MzJDYlcOL7D+iw6CUnc
	 RXiqOKrBVyvpCdCh1GSP/tkf1xz9fruGtHQaWXbI4xdAySh3MMr5XfqVDH1ElF5DK/
	 kAjQaQJpIUqQ083ySUfIYcaWZgW1gzQA7nvnSKJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.11 065/184] media: stb0899_algo: initialize cfr before using it
Date: Tue, 12 Nov 2024 11:20:23 +0100
Message-ID: <20241112101903.358429443@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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


