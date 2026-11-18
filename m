Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057081;
	b=iZLzVPceL4sOGUCjOAVfq/RsFLOKGmX91k5fduGdr0MjDX+Z9X67U2r5ZBs7TVIPstpy
	 QaDVF/tZmlSRjVlKMTfPNpg66eljIhMaCPKtGTDpkdmN0zALtKiBXFcSCFB6v+73Bev0d
	 Bn+hxAuVO5UdAX3m/ZEng1lYp9+COClXyCDaTjSod3LU/V4RqQuq0aUR5EVKJlnEbXPjf
	 0qgporiq5g0aGXYiMVRD4iIXKJLRCrqLEFo6hsMV/APA70wLE9XXBc72f+pSa8IH2+zdg
	 Yw2jPPuE9mLbGEzi7rPWQdD4wBDHoPnjZVhwTIaJ5Y+EjMC0+5mJKQuSjj9QnxX1m7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DPtnWqrEWFtKzsW56VJNbhSsoYPhastodPWOENhu9yc=;
	b=MF8lYT5uTpnT/jZTXFJdwPpNhXnP3xpHyP4BpqPc0ZJHh/Wqq8cdUB98R3KU+itukA3Y
	 3LtSv20riD/4yxdq7BENNb+rhqE4f1A/BCpqEiNmMOmZibNU6jdP6nUfkpfGVYckGpuKh
	 BpRe+jbKn9BJC3G2KdN+lAFP0aO6pqATGAvgD0aZtRL4rfvIOhUJFA8NXg0P7YFwlhgAd
	 6/ovT2rbc+08bsjUylPtuqXCfmPZCXFmrZa0IIGaYIwnyYh+CzlTwfFhcP5JXgCriXJku
	 wC7/X2hkXlY49YkObUahiaCven85TKuLneR+tUDdsWfYaInsuBGv3m2WimMLUPzPzmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JyZv9n2o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E313606A330;
	Thu, 19 Nov 2026 02:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JyZv9n2o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C73B61F000C5;
	Thu, 19 Nov 2026 02:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057081;
	bh=DPtnWqrEWFtKzsW56VJNbhSsoYPhastodPWOENhu9yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JyZv9n2osLz2A0kaqCVmc0e7SiN8t1ttMg1wq2HRMECl04ERSmMTrvQ0HkwAqtBO/
	 1eiFRiqPUOh2f2HEUnkvRsPvZ8fosRTgc7KhlM/53l4nwh4OR/Nm1SjtyubYAjOLDw
	 5jlLgdhSQ8EUa4uVh3YKXNmIJxac5rC/mGDhhlas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akira Yokosawa <akiyks@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Federico Vaga <federico.vaga@vaga.pv.it>,
	Alex Shi <alexs@kernel.org>,
	Hu Haowen <src.res@email.cn>,
	Tsugikazu Shibata <shibata@linuxfoundation.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 5.15 2210/2214] docs/process/howto: Replace C89 with C11
Date: Wed, 18 Nov 2026 16:04:46 +0100
Message-ID: <20261118150138.660390769@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akira Yokosawa <akiyks@gmail.com>

commit 2f3f53d62307262f0086804ea7cea99b0e085450 upstream.

Commit e8c07082a810 ("Kbuild: move to -std=gnu11") updated
process/programming-language.rst, but failed to update
process/howto.rst.

Update howto.rst and resolve the inconsistency.

Fixes: e8c07082a810 ("Kbuild: move to -std=gnu11")
Signed-off-by: Akira Yokosawa <akiyks@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Federico Vaga <federico.vaga@vaga.pv.it>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <src.res@email.cn>
Cc: Tsugikazu Shibata <shibata@linuxfoundation.org>
Link: https://lore.kernel.org/r/20221015092201.32099-1-akiyks@gmail.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
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
-adheres to the ISO C89 standard, it uses a number of extensions that are
+adheres to the ISO C11 standard, it uses a number of extensions that are
 not featured in the standard.  The kernel is a freestanding C
 environment, with no reliance on the standard C library, so some
 portions of the C standard are not supported.  Arbitrary long long
--- a/Documentation/translations/it_IT/process/howto.rst
+++ b/Documentation/translations/it_IT/process/howto.rst
@@ -44,7 +44,7 @@ altro, utili riferimenti:
 - "C:  A Reference Manual" di Harbison and Steele [Prentice Hall]
 
 Il kernel è stato scritto usando GNU C e la toolchain GNU.
-Sebbene si attenga allo standard ISO C89, esso utilizza una serie di
+Sebbene si attenga allo standard ISO C11, esso utilizza una serie di
 estensioni che non sono previste in questo standard. Il kernel è un
 ambiente C indipendente, che non ha alcuna dipendenza dalle librerie
 C standard, così alcune parti del C standard non sono supportate.
--- a/Documentation/translations/ja_JP/howto.rst
+++ b/Documentation/translations/ja_JP/howto.rst
@@ -65,7 +65,7 @@ Linux カーネル開発のやり方
  - 『新・詳説 C 言語 H&S リファレンス』 (サミュエル P ハービソン/ガイ L スティール共著 斉藤 信男監訳)[ソフトバンク]
 
 カーネルは GNU C と GNU ツールチェインを使って書かれています。カーネル
-は ISO C89 仕様に準拠して書く一方で、標準には無い言語拡張を多く使って
+は ISO C11 仕様に準拠して書く一方で、標準には無い言語拡張を多く使って
 います。カーネルは標準 C ライブラリに依存しない、C 言語非依存環境です。
 そのため、C の標準の中で使えないものもあります。特に任意の long long
 の除算や浮動小数点は使えません。カーネルがツールチェインや C 言語拡張
--- a/Documentation/translations/ko_KR/howto.rst
+++ b/Documentation/translations/ko_KR/howto.rst
@@ -62,7 +62,7 @@ Documentation/process/howto.rst
  - "Practical C Programming" by Steve Oualline [O'Reilly]
  - "C:  A Reference Manual" by Harbison and Steele [Prentice Hall]
 
-커널은 GNU C와 GNU 툴체인을 사용하여 작성되었다. 이 툴들은 ISO C89 표준을
+커널은 GNU C와 GNU 툴체인을 사용하여 작성되었다. 이 툴들은 ISO C11 표준을
 따르는 반면 표준에 있지 않은 많은 확장기능도 가지고 있다. 커널은 표준 C
 라이브러리와는 관계없이 freestanding C 환경이어서 C 표준의 일부는
 지원되지 않는다. 임의의 long long 나누기나 floating point는 지원되지 않는다.
--- a/Documentation/translations/zh_CN/process/howto.rst
+++ b/Documentation/translations/zh_CN/process/howto.rst
@@ -45,7 +45,7 @@ Linux内核大部分是由C语言写成�
  - "C:  A Reference Manual" by Harbison and Steele [Prentice Hall]
    《C语言参考手册（原书第5版）》（邱仲潘 等译）[机械工业出版社]
 
-Linux内核使用GNU C和GNU工具链开发。虽然它遵循ISO C89标准，但也用到了一些
+Linux内核使用GNU C和GNU工具链开发。虽然它遵循ISO C11标准，但也用到了一些
 标准中没有定义的扩展。内核是自给自足的C环境，不依赖于标准C库的支持，所以
 并不支持C标准中的部分定义。比如long long类型的大数除法和浮点运算就不允许
 使用。有时候确实很难弄清楚内核对工具链的要求和它所使用的扩展，不幸的是目
--- a/Documentation/translations/zh_TW/process/howto.rst
+++ b/Documentation/translations/zh_TW/process/howto.rst
@@ -48,7 +48,7 @@ Linux內核大部分是由C語言寫成�
  - "C:  A Reference Manual" by Harbison and Steele [Prentice Hall]
    《C語言參考手冊（原書第5版）》（邱仲潘 等譯）[機械工業出版社]
 
-Linux內核使用GNU C和GNU工具鏈開發。雖然它遵循ISO C89標準，但也用到了一些
+Linux內核使用GNU C和GNU工具鏈開發。雖然它遵循ISO C11標準，但也用到了一些
 標準中沒有定義的擴展。內核是自給自足的C環境，不依賴於標準C庫的支持，所以
 並不支持C標準中的部分定義。比如long long類型的大數除法和浮點運算就不允許
 使用。有時候確實很難弄清楚內核對工具鏈的要求和它所使用的擴展，不幸的是目


