Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619482;
	b=A7SXk5eY84avqDyKsw3oCd1SAjEs9buMKx7QH+7m1+EY7zaohxHk7VX3MHOn2nzGtaRU
	 tIUWufK4ZHUaSTmzFBbiIWcwq+wi2ei0pz0ai0t/3YDpXFUptQoszHq9jHta1tlJhfzgE
	 KEGpM3pCKhmB2UmG2iaWRMD6Zi2HLTzF7RwzuiCqCXdauui1bPrFMAUZrF5YgEX5j5fnx
	 M4eu12FTeRUuOgsKIPBT35YQBizLXMX50Ivq8fhianhLhM+MMC61+lauuyM2xz4lfWl7Q
	 dOqEnHEzVJsrZZnB7MdhsnaeEpsovlKkga8Ohll+x73gmbSQ9CKBA2fKRAIkOe0JKrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/GLetW2do/uHJZw+OByUqhtX0sneMfymE0rR1BwzD4o=;
	b=Nhtxj3eAOjsKEFyWRx/xoOFngura9ZYUvb6QtcEttfy3vKuv6O9J3NG/tH6VgJtsVFm5
	 s+nZxDRM/hYN/f7trwuya0nNXKVmHwh1GemMR5p2hsE1hYMwgmLaBeZuhDjuTL7qR/3ZQ
	 te4n1SmkikQCV76Tdz+KHb9bPl4KJt58nChHGNeA+MVNra9APfCJ5n9XZHSB/I327x88u
	 aWiTapHFnRGQuLxTFCd85ziKRRneg94putr24Tq4foFHl913k5zRidR1qmKvI7P8RNHOp
	 wbNsglpbo+aHZxMh4Whs3oNpmoKJn3VOmYmma9IkApC13++cEXs23iNgDBoWVsv8aJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7bpfwpY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEE3606A31E;
	Wed, 25 Nov 2026 15:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7bpfwpY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3D71F000C0;
	Wed, 25 Nov 2026 15:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619481;
	bh=/GLetW2do/uHJZw+OByUqhtX0sneMfymE0rR1BwzD4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7bpfwpY5buTp91MFsksEDZpkKU465Zo0MTe8iP30buSnxwJZJj2PVckQuIJsGfgE
	 /F0Pv36nG4iovF/CfpIJ4EY+OE74Q8VRFhQZcaaGXDUeHlWsVlr++5j6O4P+4ZdiAF
	 9uBpEt2gBuRUIJg2cjFFAIozY5Gc2RC5O1r30VjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduardo Mucelli Rezende Oliveira <edumucelli@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.3 0611/1005] bootconfig: Trim unquoted values at end of file
Date: Wed, 25 Nov 2026 15:32:29 +0100
Message-ID: <20261125143836.056851248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/bootconfig.c                    |    5 +++--
 tools/bootconfig/test-bootconfig.sh |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

--- a/lib/bootconfig.c
+++ b/lib/bootconfig.c
@@ -790,16 +790,17 @@ static int __init __xbc_parse_value(char
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
@@ -171,6 +171,24 @@ $BOOTCONF $INITRD > $OUTFILE
 xfail grep -q 'val[[:space:]]' $OUTFILE
 xpass grep -q 'val2[[:space:]]' $OUTFILE
 
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
 echo "Showing correct line:column of no closing brace"
 cat > $TEMPCONF << EOF
 foo {


