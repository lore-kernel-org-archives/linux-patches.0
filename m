Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704851;
	b=sdEGWj5NMV1k7722hZhCfDrDYMzuIdWxQ2Pw8JGhwoRTB9iLQfFuhiSUlcYlLFzYtYm1
	 MJxudOP7VzxMuGBWI/z4HjcaaMTmO+i7kbQ3Yv9PmtSIMLyKix+bLf59FtamWH2MlEpqD
	 lT8Ol214hQ4GWl5rjWelqTYEDwrRFvy4GBVB/EwAy0CehjTODN7NZ4EsNC44P71d16rvG
	 8m01rzYt515lm63fAw5wrRR1FHFNA5bcmb5y0t5TnYwhgDSFPlm+qKzH41FtscrvWohEp
	 xw1AxDmW0lvDCTcqSNic9COLreOG0Wdom9nPCwoRuKRHd1nYMIpz/Fz22um2tJqWdSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HHLK/HEEpd+0pnTNFAFsVV4MCQdt3WBxms10r160Y/4=;
	b=G+feck1bNLTopp8ktzI92HPe4KU1HvdNhT+w6ItCFZt4Zo9vakTQn28YadrF8XC/SD2z
	 ZIuwEirEl6qqR4gMJGyBg94xhiVtzJDZks2ly7QUjUGmyruYnPxltS2gFduq1SWyEa7tV
	 VLIvDQD9f0liLuKPKu/6GxgjqgcrTrGyIb/Sk28OKMiLJqCiKUobi8yvC3k4o5KZMJQ1C
	 KCzJ8uAUy3guj+tFdeJz49gGm/MDnmjRWaos9lI78DGDdXx31I75WuyV9CSxRkPqILxsV
	 osndSrxhki7ZZYD+oMmB7daxnzhyDS3H0Tfd0D3SiMFKlO6aE3bJQocpPVafTCiqsPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vDf4DQrs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102E6606A326;
	Thu, 26 Nov 2026 14:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vDf4DQrs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056E01F000C4;
	Thu, 26 Nov 2026 14:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704850;
	bh=HHLK/HEEpd+0pnTNFAFsVV4MCQdt3WBxms10r160Y/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vDf4DQrsY3yp4IJCrHlc+KWRNuhynYoW4xBru6oWHJA1DbtUeoanrI/D8t41ioPhX
	 NEk3M8vupto3Vl+urXK4Os0Jcca4ogcJWB1tJ/e5Bm7xJlZHsmcP4408OsQSwmCZjg
	 fGYTJh6ByNZNBN6GYMFNP36tkrp6Aezrfk3fNtOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduardo Mucelli Rezende Oliveira <edumucelli@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.10 263/265] bootconfig: Trim unquoted values at end of file
Date: Thu, 26 Nov 2026 15:39:53 +0100
Message-ID: <20261126143623.627796757@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduardo Mucelli Rezende Oliveira <edumucelli@gmail.com>

commit 381b391bfaa3f10d52da4740529804b0b6b8160d upstream.

__xbc_parse_value() trims an unquoted value when it encounters a
delimiter, but leaves trailing whitespace intact when it reaches the end
of the input. Thus "key = value   " has a different value depending on
whether the file ends with a newline. The extra whitespace also reaches
the rendered kernel command line.

Trim unquoted values after the scan finishes, including at end of input.
Skip trimming after a closing quote so intentional whitespace in quoted
values remains unchanged. Add checks for scalars, arrays and quoted
values without a final newline.

Link: https://lore.kernel.org/all/31f248f330e716b925add3a0ba76f62826527312.1794337724.git.edumucelli@gmail.com/

Fixes: 76db5a27a827 ("bootconfig: Add Extra Boot Config support")
Cc: stable@vger.kernel.org
Signed-off-by: Eduardo Mucelli Rezende Oliveira <edumucelli@gmail.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Eduardo Mucelli Rezende Oliveira <edumucelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/bootconfig.c                    |    5 +++--
 tools/bootconfig/test-bootconfig.sh |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -556,16 +556,17 @@ static int __init __xbc_parse_value(char
 				return xbc_parse_error("No value delimiter", p);
 			if (*p)
 				p++;
-			break;
+			goto skip_trim;
 		}
 		if (strchr(",;\n#}", c)) {
 			*p++ = '\0';
-			v = strim(v);
 			break;
 		}
 	}
 	if (quotes)
 		return xbc_parse_error("No closing quotes", p);
+	v = strim(v);
+skip_trim:
 	if (c == '#') {
 		p = skip_comment(p);
 		c = '\n';	/* A comment must be treated as a newline */
--- a/tools/bootconfig/test-bootconfig.sh
+++ b/tools/bootconfig/test-bootconfig.sh
@@ -170,6 +170,24 @@ $BOOTCONF $INITRD > $OUTFILE
 xfail grep -q val[[:space:]] $OUTFILE
 xpass grep -q val2[[:space:]] $OUTFILE
 
+echo "Remove unquoted trailing whitespace at end of file"
+printf 'foo = val \t' > $TEMPCONF
+$BOOTCONF -l $TEMPCONF > $OUTFILE
+printf 'foo = "val"\n' > $TEMPCONF
+xpass cmp $TEMPCONF $OUTFILE
+
+echo "Remove trailing whitespace from the last array value at end of file"
+printf 'foo = first, last \t' > $TEMPCONF
+$BOOTCONF -l $TEMPCONF > $OUTFILE
+printf 'foo = "first", "last"\n' > $TEMPCONF
+xpass cmp $TEMPCONF $OUTFILE
+
+echo "Keep quoted trailing whitespace at end of file"
+printf 'foo = "val "' > $TEMPCONF
+$BOOTCONF -l $TEMPCONF > $OUTFILE
+printf 'foo = "val "\n' > $TEMPCONF
+xpass cmp $TEMPCONF $OUTFILE
+
 echo "=== expected failure cases ==="
 for i in samples/bad-* ; do
   xfail $BOOTCONF -a $i $INITRD


