Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C85D279DC9;
	Sat, 30 May 2026 18:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165588; cv=none; b=uir98uxEW9xlzKAkHFaVl1vHW8XJ3smCopKAn6bEUW0+VnEgOwAzWD83Yyedh70gmBTIi3xeZIwLEeUt9XA3NTsbe2msNNHoq6RRAwS+n6+zmm7qJ/6Rz31Sd8XdYsKoeObzpPuVSC77qXQUptsHJcJVG860pqGJzjR8kQG2iZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165588; c=relaxed/simple;
	bh=LOLGSp2v0jqdPbIswTDpmbZi9gGXkyeaE27tDGy4vR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WxQvoBMYjToJT3N8Y4T7KirFCTZU5FhDqc1YNn+yvkKzQW32SxnDjAwEqxQ4Ijtf7oi5MELhzq9FULvJTMtAD3UUtLzQWkyjY7KOCjgYh6IoPxrlDdFlik8WeEo68EWmm2/43FylmPqh85W2ojTw3roThP3HnXKxibThLLNR/vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQUd/7Bm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQUd/7Bm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6059E1F00893;
	Sat, 30 May 2026 18:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165587;
	bh=nFsz5f2Jv/YkUV3v1O//B9oIp4WJOf2pnaJTUeIzFIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rQUd/7BmwyHouTGuGNlMfOowPD2slEG9HiTTTqeXe5AWpzg4GbA82lTwWPzokEovZ
	 6vBIgcoLyNbut7tIlgnEZEQpLvIC8gxPl6sg5spCBpCB8ZMLNPac8t2ceBI2RQi4pl
	 xHVZkna+hKQ3lVS/HCZCHDm1GUSW4jy/6l8oHsDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, devicetree@vger.kernel.org,  Nathan Chancellor" <nathan@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.10 122/589] scripts/dtc: Remove unused dts_version in dtc-lexer.l
Date: Sat, 30 May 2026 18:00:03 +0200
Message-ID: <20260530160227.971184681@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

This patch is for stable only. Commit 5a09df20872c ("scripts/dtc: Update
to upstream version v1.7.2-69-g53373d135579") upstream applied it as
part of a regular scripts/dtc sync, which may be unsuitable for older
versions of stable where the warning it fixes is present.

A recent strengthening of -Wunused-but-set-variable (enabled with -Wall)
in clang under a new subwarning, -Wunused-but-set-global, points out an
unused static global variable in dtc-lexer.lex.c (compiled from
dtc-lexer.l):

  scripts/dtc/dtc-lexer.lex.c:641:12: warning: variable 'dts_version' set but not used [-Wunused-but-set-global]
    641 | static int dts_version = 1;
        |            ^

Remove it to clear up the warning, as it is truly unused.

Fixes: 658f29a51e98 ("of/flattree: Update dtc to current mainline.")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
This should apply cleanly to all supported stable branches.
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/dtc/dtc-lexer.l |    3 ---
 1 file changed, 3 deletions(-)

--- a/scripts/dtc/dtc-lexer.l
+++ b/scripts/dtc/dtc-lexer.l
@@ -39,8 +39,6 @@ extern bool treesource_error;
 #define DPRINT(fmt, ...)	do { } while (0)
 #endif
 
-static int dts_version = 1;
-
 #define BEGIN_DEFAULT()		DPRINT("<V1>\n"); \
 				BEGIN(V1); \
 
@@ -101,7 +99,6 @@ static void PRINTF(1, 2) lexical_error(c
 
 <*>"/dts-v1/"	{
 			DPRINT("Keyword: /dts-v1/\n");
-			dts_version = 1;
 			BEGIN_DEFAULT();
 			return DT_V1;
 		}


