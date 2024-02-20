Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C44152E10;
	Tue, 20 Feb 2024 21:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464030; cv=none; b=HRIqs3AnMn41RwRq1QsuyTcQntKpNAVnxQm8hziM7wIJ2Ibgpf3uJnJKiztqZpHVlzbXROwPlay3zGJ4GjNCQN6gtIt7QZ53MjYdv5OcQbiVXSJoNVX7isb2ZZSGWPgl4v2s+IO4xTqIqpPlVATsJTPZ17J41zPfMBe7uao5OqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464030; c=relaxed/simple;
	bh=IFg4GXo17ByyPpgfU1TILx7b89IXDY3eVHRGMwRZCo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzRNQuY3ZLtfwFwqZQyPL/+KM7kKUv+Qmy73j+JzL+toaORqufojj+QDtzEJgYyDemIizZeDxTovt8khujtQ7rsUivHOVG0BCM5zC6SdvA536o15eCerM9IM2zSq7nZJFu4KvecwP6uRePCT1cwt8i0LfKmLw0JFBcedStLJPxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jAbac2t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jAbac2t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E39C433C7;
	Tue, 20 Feb 2024 21:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464029;
	bh=IFg4GXo17ByyPpgfU1TILx7b89IXDY3eVHRGMwRZCo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jAbac2tHslM1aNlDek6zy/Iymy+aDDR4lHe5tNnQKTGnKOTkwb0S7mZMUo+BC8SS
	 t1psXjfO+0DfzRhIBiyru9dd2BprVg1BkRZAyrd3rjIhJ0kWYIomoytsEFcXGmLaEG
	 XwdeXV8YA84vDvYgqmtpnEiPKwZQgE+4Eq4pTNcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Daniel Bristot de Oliveira <bristot@kernel.org>
Subject: [PATCH 6.6 229/331] tools/rtla: Exit with EXIT_SUCCESS when help is invoked
Date: Tue, 20 Feb 2024 21:55:45 +0100
Message-ID: <20240220205644.963906070@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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


