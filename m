Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33CE343D75;
	Wed,  3 Dec 2025 15:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777472; cv=none; b=XCTX6Ctj0+793ARXNiECu5SjBUx4I3JhB53qfOrlQt2IrNAyYT/VmNaXUph1hpgHvZxx3y+Mn/+DVgxPJq+2IKXgsxE/WvMTu0zQ4PlLqv7stE/L3gUts7fm+8E/aFBVV6sSSArO74YvZFaEhMuzKmqaRjyQ+vNSN8Y2azbKKJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777472; c=relaxed/simple;
	bh=aYwsdc2uGxdVQkvFRScPMT9KlBmPWnPVa2PwKk0REso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=harqZdI7VtyMIpi5iBl/i+oFsmqyiX1YJzNJx4zDCTt4obG2oBLSa41gNp8cLR63NBzgMya784jPkxDqDdGRtP2rVuAfyXp5m14jB+kZmdiX2dEkmZgfWVn/qglIgg45jUBaeee+jCSZ/VvDai+uxptuV3fSXaYkxv5fEW/PzZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQ6XD6m+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQ6XD6m+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4208BC4CEF5;
	Wed,  3 Dec 2025 15:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777472;
	bh=aYwsdc2uGxdVQkvFRScPMT9KlBmPWnPVa2PwKk0REso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQ6XD6m+vbWOHVC4x1pZuR4fA8u5D8xum7oszsaWiymrf56Y1+2vYbUB+GcX5tPVj
	 k0329Pp571OAUxum2F+yIVby5MmOa4JXqJetx2FKzkju3qyxID9qyMCrhNk84ppHlt
	 4YikdDzwJ0xqSfcc9L/s8k766/PdZEygE374FHMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Akira Yokosawa <akiyks@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Federico Vaga <federico.vaga@vaga.pv.it>,
	Alex Shi <alexs@kernel.org>,
	Hu Haowen <src.res@email.cn>,
	Tsugikazu Shibata <shibata@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.15 048/392] Revert "docs/process/howto: Replace C89 with C11"
Date: Wed,  3 Dec 2025 16:23:18 +0100
Message-ID: <20251203152415.879652479@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

This reverts commit dc52117cd797f71f9686fa0cec91509eb7a9623d which is
commit 2f3f53d62307262f0086804ea7cea99b0e085450 upstream.

In this kernel version, C89 is still the default ISO standard.

The reverted commit was fixing commit e8c07082a810 ("Kbuild: move to
-std=gnu11"), introduced in v5.18, and not backported to older versions.
It was then not supported to be backported to v5.15. It can then safely
be reverted.

Fixes: 2f3f53d62307 ("docs/process/howto: Replace C89 with C11")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: Akira Yokosawa <akiyks@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Federico Vaga <federico.vaga@vaga.pv.it>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <src.res@email.cn>
Cc: Tsugikazu Shibata <shibata@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/process/howto.rst                    |    2 +-
 Documentation/translations/it_IT/process/howto.rst |    2 +-
 Documentation/translations/ja_JP/howto.rst         |    2 +-
 Documentation/translations/ko_KR/howto.rst         |    2 +-
 Documentation/translations/zh_CN/process/howto.rst |    2 +-
 Documentation/translations/zh_TW/process/howto.rst |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/process/howto.rst
+++ b/Documentation/process/howto.rst
@@ -36,7 +36,7 @@ experience, the following books are good
  - "C:  A Reference Manual" by Harbison and Steele [Prentice Hall]
 
 The kernel is written using GNU C and the GNU toolchain.  While it
-adheres to the ISO C11 standard, it uses a number of extensions that are
+adheres to the ISO C89 standard, it uses a number of extensions that are
 not featured in the standard.  The kernel is a freestanding C
 environment, with no reliance on the standard C library, so some
 portions of the C standard are not supported.  Arbitrary long long
--- a/Documentation/translations/it_IT/process/howto.rst
+++ b/Documentation/translations/it_IT/process/howto.rst
@@ -44,7 +44,7 @@ altro, utili riferimenti:
 - "C:  A Reference Manual" di Harbison and Steele [Prentice Hall]
 
 Il kernel è stato scritto usando GNU C e la toolchain GNU.
-Sebbene si attenga allo standard ISO C11, esso utilizza una serie di
+Sebbene si attenga allo standard ISO C89, esso utilizza una serie di
 estensioni che non sono previste in questo standard. Il kernel è un
 ambiente C indipendente, che non ha alcuna dipendenza dalle librerie
 C standard, così alcune parti del C standard non sono supportate.
--- a/Documentation/translations/ja_JP/howto.rst
+++ b/Documentation/translations/ja_JP/howto.rst
@@ -65,7 +65,7 @@ Linux カーネル開発のやり方
  - 『新・詳説 C 言語 H&S リファレンス』 (サミュエル P ハービソン/ガイ L スティール共著 斉藤 信男監訳)[ソフトバンク]
 
 カーネルは GNU C と GNU ツールチェインを使って書かれています。カーネル
-は ISO C11 仕様に準拠して書く一方で、標準には無い言語拡張を多く使って
+は ISO C89 仕様に準拠して書く一方で、標準には無い言語拡張を多く使って
 います。カーネルは標準 C ライブラリに依存しない、C 言語非依存環境です。
 そのため、C の標準の中で使えないものもあります。特に任意の long long
 の除算や浮動小数点は使えません。カーネルがツールチェインや C 言語拡張
--- a/Documentation/translations/ko_KR/howto.rst
+++ b/Documentation/translations/ko_KR/howto.rst
@@ -62,7 +62,7 @@ Documentation/process/howto.rst
  - "Practical C Programming" by Steve Oualline [O'Reilly]
  - "C:  A Reference Manual" by Harbison and Steele [Prentice Hall]
 
-커널은 GNU C와 GNU 툴체인을 사용하여 작성되었다. 이 툴들은 ISO C11 표준을
+커널은 GNU C와 GNU 툴체인을 사용하여 작성되었다. 이 툴들은 ISO C89 표준을
 따르는 반면 표준에 있지 않은 많은 확장기능도 가지고 있다. 커널은 표준 C
 라이브러리와는 관계없이 freestanding C 환경이어서 C 표준의 일부는
 지원되지 않는다. 임의의 long long 나누기나 floating point는 지원되지 않는다.
--- a/Documentation/translations/zh_CN/process/howto.rst
+++ b/Documentation/translations/zh_CN/process/howto.rst
@@ -45,7 +45,7 @@ Linux内核大部分是由C语言写成�
  - "C:  A Reference Manual" by Harbison and Steele [Prentice Hall]
    《C语言参考手册（原书第5版）》（邱仲潘 等译）[机械工业出版社]
 
-Linux内核使用GNU C和GNU工具链开发。虽然它遵循ISO C11标准，但也用到了一些
+Linux内核使用GNU C和GNU工具链开发。虽然它遵循ISO C89标准，但也用到了一些
 标准中没有定义的扩展。内核是自给自足的C环境，不依赖于标准C库的支持，所以
 并不支持C标准中的部分定义。比如long long类型的大数除法和浮点运算就不允许
 使用。有时候确实很难弄清楚内核对工具链的要求和它所使用的扩展，不幸的是目
--- a/Documentation/translations/zh_TW/process/howto.rst
+++ b/Documentation/translations/zh_TW/process/howto.rst
@@ -48,7 +48,7 @@ Linux內核大部分是由C語言寫成�
  - "C:  A Reference Manual" by Harbison and Steele [Prentice Hall]
    《C語言參考手冊（原書第5版）》（邱仲潘 等譯）[機械工業出版社]
 
-Linux內核使用GNU C和GNU工具鏈開發。雖然它遵循ISO C11標準，但也用到了一些
+Linux內核使用GNU C和GNU工具鏈開發。雖然它遵循ISO C89標準，但也用到了一些
 標準中沒有定義的擴展。內核是自給自足的C環境，不依賴於標準C庫的支持，所以
 並不支持C標準中的部分定義。比如long long類型的大數除法和浮點運算就不允許
 使用。有時候確實很難弄清楚內核對工具鏈的要求和它所使用的擴展，不幸的是目


