Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F464F5ED;
	Mon,  1 Apr 2024 18:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711995867; cv=none; b=Yt4l0Fe86x7WNKYqO/Pd9h82rNOI2C4JwCEmE+Feh4jB1z02foioFh2kcigpZ7SVP+fzUC9nEkgWOpW+cK6YBC1LuQuXwM2Is5d9DG43KQgEdur0xNlanLV/kGkNp+qUTc3bzrzlifirp/e3wov8882gy2u4Uxo/jo8h6R04rHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711995867; c=relaxed/simple;
	bh=v5//NGqmsFVDnGzhvsk7EyqTibVqjq4qRRtWuGQKJsE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=NPuVuMbu9TXTSszgcduUx4bgn2PNygMFFEvvxrL2dKAcwtac3fAQESjry6HLcACW5KaIowkiG8EaHCexi7aFHY1TISOYjt1yG3yG253vNy1y/FeEYTZb6DUTGyMrPGTMwWOx2aIXv6jgLnAsLiofwbY+GRjJYfg1Dh58eoq/Kqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SGpDzeDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SGpDzeDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14369C433C7;
	Mon,  1 Apr 2024 18:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711995865;
	bh=v5//NGqmsFVDnGzhvsk7EyqTibVqjq4qRRtWuGQKJsE=;
	h=From:Date:Subject:To:Cc:From;
	b=SGpDzeDq6M9jklr2zsSGYXjkwLg/8vHciarHq5sG97XFBCjttynIM86XN4UOhD7Ql
	 CHB9RP69aOmjV/9jNGDX1RVsIPIMpDdzdvvdio43O1savIEro+l0AaD3wjaTjJBnGC
	 fWhNfI/jS/N1GixCAQd99Bc59Kkd5zXzxEVRUM1NlIYBY6PioVD4yLi4i2PoHs9CLM
	 uRVApnm0CQwFq5+kSZwiO/h7e9H+WKn0cSP4JixZNE/Kf5N6x3cRg554edOdJjY8aD
	 wSZzUGbRsHav6ZS+3vPzZCEDo/MT33Gzxzx9CvgGf5UxIh+5/z/jPV99RGMTcSsbDJ
	 hkwhu2NBATBhw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 01 Apr 2024 11:24:17 -0700
Subject: [PATCH bluetooth] Bluetooth: Fix type of len in
 {l2cap,sco}_sock_getsockopt_old()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240401-bluetooth-fix-len-type-getsockopt_old-v1-1-c6b5448b5374@kernel.org>
X-B4-Tracking: v=1; b=H4sIAND7CmYC/z2N0QrCMAwAf2Xk2UC3BRV/RWTMLm7B0pQ2ymTs3
 y0++Hhw3G1QOAsXuDQbZH5LEY0V2kMDfhnjzChTZehcR45ci/fwYlO1BR+yYuCI9kmMM1tR/9R
 kg4YJT72n8cxHR0RQWylz1X+fK/wTcNv3L5/jXoKCAAAA
To: marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com
Cc: ndesaulniers@google.com, morbo@google.com, justinstitt@google.com, 
 keescook@chromium.org, linux-bluetooth@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5307; i=nathan@kernel.org;
 h=from:subject:message-id; bh=v5//NGqmsFVDnGzhvsk7EyqTibVqjq4qRRtWuGQKJsE=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGlcv29EWk/amRpT3Nr2VGzu/oTbVYImwfyfQnaxlYfPS
 N1wuP1TRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZiI0StGhvk1s5OWXF35WvDt
 lcK2PsOfIrtDFgQuvyqXs55BWPbhx1cM/7PkptzwmNkTIakytasoSOmrgoQPe1iBrED21poDVy/
 cYwYA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After an innocuous optimization change in LLVM main (19.0.0), x86_64
allmodconfig (which enables CONFIG_KCSAN / -fsanitize=thread) fails to
build due to the checks in check_copy_size():

  In file included from net/bluetooth/sco.c:27:
  In file included from include/linux/module.h:13:
  In file included from include/linux/stat.h:19:
  In file included from include/linux/time.h:60:
  In file included from include/linux/time32.h:13:
  In file included from include/linux/timex.h:67:
  In file included from arch/x86/include/asm/timex.h:6:
  In file included from arch/x86/include/asm/tsc.h:10:
  In file included from arch/x86/include/asm/msr.h:15:
  In file included from include/linux/percpu.h:7:
  In file included from include/linux/smp.h:118:
  include/linux/thread_info.h:244:4: error: call to '__bad_copy_from' declared with 'error' attribute: copy source size is too small
    244 |                         __bad_copy_from();
        |                         ^

The same exact error occurs in l2cap_sock.c. The copy_to_user()
statements that are failing come from l2cap_sock_getsockopt_old() and
sco_sock_getsockopt_old(). This does not occur with GCC with or without
KCSAN or Clang without KCSAN enabled.

len is defined as an 'int' because it is assigned from
'__user int *optlen'. However, it is clamped against the result of
sizeof(), which has a type of 'size_t' ('unsigned long' for 64-bit
platforms). This is done with min_t() because min() requires compatible
types, which results in both len and the result of sizeof() being casted
to 'unsigned int', meaning len changes signs and the result of sizeof()
is truncated. From there, len is passed to copy_to_user(), which has a
third parameter type of 'unsigned long', so it is widened and changes
signs again. This excessive casting in combination with the KCSAN
instrumentation causes LLVM to fail to eliminate the __bad_copy_from()
call, failing the build.

The official recommendation from LLVM developers is to consistently use
long types for all size variables to avoid the unnecessary casting in
the first place. Change the type of len to size_t in both
l2cap_sock_getsockopt_old() and sco_sock_getsockopt_old(). This clears
up the error while allowing min_t() to be replaced with min(), resulting
in simpler code with no casts and fewer implicit conversions. While len
is a different type than optlen now, it should result in no functional
change because the result of sizeof() will clamp all values of optlen in
the same manner as before.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2007
Link: https://github.com/llvm/llvm-project/issues/85647
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 7 ++++---
 net/bluetooth/sco.c        | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 4287aa6cc988..81193427bf05 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -439,7 +439,8 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
 	struct l2cap_options opts;
 	struct l2cap_conninfo cinfo;
-	int len, err = 0;
+	int err = 0;
+	size_t len;
 	u32 opt;
 
 	BT_DBG("sk %p", sk);
@@ -486,7 +487,7 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 
 		BT_DBG("mode 0x%2.2x", chan->mode);
 
-		len = min_t(unsigned int, len, sizeof(opts));
+		len = min(len, sizeof(opts));
 		if (copy_to_user(optval, (char *) &opts, len))
 			err = -EFAULT;
 
@@ -536,7 +537,7 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 		cinfo.hci_handle = chan->conn->hcon->handle;
 		memcpy(cinfo.dev_class, chan->conn->hcon->dev_class, 3);
 
-		len = min_t(unsigned int, len, sizeof(cinfo));
+		len = min(len, sizeof(cinfo));
 		if (copy_to_user(optval, (char *) &cinfo, len))
 			err = -EFAULT;
 
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 43daf965a01e..9a72d7f1946c 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -967,7 +967,8 @@ static int sco_sock_getsockopt_old(struct socket *sock, int optname,
 	struct sock *sk = sock->sk;
 	struct sco_options opts;
 	struct sco_conninfo cinfo;
-	int len, err = 0;
+	int err = 0;
+	size_t len;
 
 	BT_DBG("sk %p", sk);
 
@@ -989,7 +990,7 @@ static int sco_sock_getsockopt_old(struct socket *sock, int optname,
 
 		BT_DBG("mtu %u", opts.mtu);
 
-		len = min_t(unsigned int, len, sizeof(opts));
+		len = min(len, sizeof(opts));
 		if (copy_to_user(optval, (char *)&opts, len))
 			err = -EFAULT;
 
@@ -1007,7 +1008,7 @@ static int sco_sock_getsockopt_old(struct socket *sock, int optname,
 		cinfo.hci_handle = sco_pi(sk)->conn->hcon->handle;
 		memcpy(cinfo.dev_class, sco_pi(sk)->conn->hcon->dev_class, 3);
 
-		len = min_t(unsigned int, len, sizeof(cinfo));
+		len = min(len, sizeof(cinfo));
 		if (copy_to_user(optval, (char *)&cinfo, len))
 			err = -EFAULT;
 

---
base-commit: 7835fcfd132eb88b87e8eb901f88436f63ab60f7
change-id: 20240401-bluetooth-fix-len-type-getsockopt_old-73c4a8e60444

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

