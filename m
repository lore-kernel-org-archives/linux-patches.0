Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D793133987;
	Tue, 20 Feb 2024 21:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463141; cv=none; b=gHOs0RduyZeGR9r/6Uymdlr2+ZaHJzIDXvf8WlLOhf+tpf0oAgHXZrszbP1kjw12FVBeWjM/SKlGV6OnVsQMElOjVDqGoUPQ96ChKUvRJAqgmFKIFxPtyScEFT0YvltcQJImaPstcNMsHJa0Rz0XpRWXXJX8xxuLmYGVD+1r7wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463141; c=relaxed/simple;
	bh=3nxICxc39285JlZubejWGC1kG9DQ889E47wwNmjHtPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izVjcVMbDk1EjihQMsx+kPOBlDETc3sQw4FB72g9Lvg+K7KOBj1IP+igYr/WqCIkUzGpK0KYpJ0CmCabJVD31uNj3WIRigBOxjuaSKW9CRHyoZEOxVL8pszzsVYlvdoLi8t0J4SD1s2kt2vrSm32O+ZY1cTQdrTxBXOZMFudjLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXi70Jzt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXi70Jzt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3312C433C7;
	Tue, 20 Feb 2024 21:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463141;
	bh=3nxICxc39285JlZubejWGC1kG9DQ889E47wwNmjHtPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXi70JztHgFAHdSMp/AjRxpn/pLI3lheHlqNDg4qqhR0DCgnJYZ0e1p0/I8ZFVh5M
	 OtFYKHwXJ2UaFrhdJFNm1pk7xMFzt8s6rjIE7b6HJbmzjn7dvzsYbdRLfexM3CnaHT
	 8MZbXm/aiwnlSglj3NYk5w/M52z/fcdeEbuQPO60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [PATCH 6.1 149/197] tools/rtla: Exit with EXIT_SUCCESS when help is invoked
Date: Tue, 20 Feb 2024 21:51:48 +0100
Message-ID: <20240220204845.533499801@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Kacur <jkacur@redhat.com>

commit b5f319360371087d52070d8f3fc7789e80ce69a6 upstream.

Fix rtla so that the following commands exit with 0 when help is invoked

rtla osnoise top -h
rtla osnoise hist -h
rtla timerlat top -h
rtla timerlat hist -h

Link: https://lore.kernel.org/linux-trace-devel/20240203001607.69703-1-jkacur@redhat.com

Cc: stable@vger.kernel.org
Fixes: 1eeb6328e8b3 ("rtla/timerlat: Add timerlat hist mode")
Signed-off-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/osnoise_hist.c  |    6 +++++-
 tools/tracing/rtla/src/osnoise_top.c   |    6 +++++-
 tools/tracing/rtla/src/timerlat_hist.c |    6 +++++-
 tools/tracing/rtla/src/timerlat_top.c  |    6 +++++-
 4 files changed, 20 insertions(+), 4 deletions(-)

--- a/tools/tracing/rtla/src/osnoise_hist.c
+++ b/tools/tracing/rtla/src/osnoise_hist.c
@@ -472,7 +472,11 @@ static void osnoise_hist_usage(char *usa
 
 	for (i = 0; msg[i]; i++)
 		fprintf(stderr, "%s\n", msg[i]);
-	exit(1);
+
+	if (usage)
+		exit(EXIT_FAILURE);
+
+	exit(EXIT_SUCCESS);
 }
 
 /*
--- a/tools/tracing/rtla/src/osnoise_top.c
+++ b/tools/tracing/rtla/src/osnoise_top.c
@@ -282,7 +282,11 @@ void osnoise_top_usage(char *usage)
 
 	for (i = 0; msg[i]; i++)
 		fprintf(stderr, "%s\n", msg[i]);
-	exit(1);
+
+	if (usage)
+		exit(EXIT_FAILURE);
+
+	exit(EXIT_SUCCESS);
 }
 
 /*
--- a/tools/tracing/rtla/src/timerlat_hist.c
+++ b/tools/tracing/rtla/src/timerlat_hist.c
@@ -475,7 +475,11 @@ static void timerlat_hist_usage(char *us
 
 	for (i = 0; msg[i]; i++)
 		fprintf(stderr, "%s\n", msg[i]);
-	exit(1);
+
+	if (usage)
+		exit(EXIT_FAILURE);
+
+	exit(EXIT_SUCCESS);
 }
 
 /*
--- a/tools/tracing/rtla/src/timerlat_top.c
+++ b/tools/tracing/rtla/src/timerlat_top.c
@@ -305,7 +305,11 @@ static void timerlat_top_usage(char *usa
 
 	for (i = 0; msg[i]; i++)
 		fprintf(stderr, "%s\n", msg[i]);
-	exit(1);
+
+	if (usage)
+		exit(EXIT_FAILURE);
+
+	exit(EXIT_SUCCESS);
 }
 
 /*


