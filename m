Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6109C612D7;
	Tue, 20 Feb 2024 21:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465224; cv=none; b=kl0H0bclhjRhAUW+YXjPd2UW7O/RjpgQAR416+INsZh81fScXTGJ4byCn2W40D0hJjLzZdv9fu6mw2acgMFv3ZzJ0YwUQT6qfiaWD663SkFJHxcn6hXTYZC+3iCibeA9oC+FHEO5z16O5F2sI8lTGrh5o+3leQW/nXR1tg6+1Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465224; c=relaxed/simple;
	bh=rd8yQ7wnmfvmb6yA1wdmyzKvUG8/JPwkLSVyyel92hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYUYEMRRab8iHkeeufWegspUv7vtN/dqozCXr/bVXkTZ6GXuynAhvOwDxp/HR4f9LU4kj/j1TD3XhFNQblRijOJOZ+3ksyJOf7xSxhlA96VlnnYCtw0YW4cp5MW7Y3QMRBzVEV9Ls/kCAESOZoS8fOKDROg8aZ9x8zX8YDwQTFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulFSXda4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulFSXda4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FB7C433F1;
	Tue, 20 Feb 2024 21:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465224;
	bh=rd8yQ7wnmfvmb6yA1wdmyzKvUG8/JPwkLSVyyel92hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulFSXda41+VNrGEZtMweGOyYUzDneR9fFai7P4dwVGxGBPSQjQHFA9Jy0JnJzmHRB
	 8fH7zrUYqp0M6E0vYt0TqwDkAz/0Y/e1jopCryJKqzrrW3l8c0UFnVitvvP+faTdks
	 mgQjTB9aeiFBuRbsHJk0afm1//uECrqyHFNYOyU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [PATCH 6.7 275/309] tools/rtla: Exit with EXIT_SUCCESS when help is invoked
Date: Tue, 20 Feb 2024 21:57:14 +0100
Message-ID: <20240220205641.730965462@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -480,7 +480,11 @@ static void osnoise_hist_usage(char *usa
 
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
@@ -331,7 +331,11 @@ static void osnoise_top_usage(struct osn
 
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
@@ -546,7 +546,11 @@ static void timerlat_hist_usage(char *us
 
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
@@ -375,7 +375,11 @@ static void timerlat_top_usage(char *usa
 
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


