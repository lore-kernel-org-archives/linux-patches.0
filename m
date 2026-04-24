Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F38C19A288;
	Fri, 24 Apr 2026 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038174; cv=none; b=Isp86wfyX/wDq8iAaU4/p62bK//w28W2vkUGevfx2TxVNE8eCshb7xp5xtLSYPzonJkvWWYKtZqtf8mA2a/4fLU5l9ImN+ergl2IOKuidrFn/GfJjN3owUHZPm+twQjOMs6RslIf+LFfJ7FrB4bYEwxg2eGzWgVkcXxfAWTwa5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038174; c=relaxed/simple;
	bh=j4OmY/NPQ2ArpfLgSgUw6+X0knavZVQuBmLXPkPXjGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfKlGnRMrXwxGWJrgkTgnNXByLetnbHo4U8F+07rhuWrH1d8ZY98hPy0IBgE+hIKzX4f5iTLXidbODkx7B1gI2x0hBiFVpLTkiSKg3cFbQWCLoZ8kA31WoJKUBmEmQxvzvXwGM+zO1a1RvuY011SoWPE9OGkYA+ZQqzlL7k28Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTcaWbdA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTcaWbdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9085C19425;
	Fri, 24 Apr 2026 13:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038174;
	bh=j4OmY/NPQ2ArpfLgSgUw6+X0knavZVQuBmLXPkPXjGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTcaWbdA95KkRuLIsutMNo+3hWIQpRoChvwahpfxfn3huY5hUgWXEamk9gsMxb62y
	 niuO+gER84T9wEbgIFSj6ff14z+rIIeoA77sxDVdD6VfvIs3/fbc9bhxpxdQAupa59
	 wCkaslVNl+AtE3qlNNADriSO01hjhKf01dKceCvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"stable@vger.kernel.org, devicetree@vger.kernel.org,  Nathan Chancellor" <nathan@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.18 25/55] scripts/dtc: Remove unused dts_version in dtc-lexer.l
Date: Fri, 24 Apr 2026 15:31:04 +0200
Message-ID: <20260424132435.250369801@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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


