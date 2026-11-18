Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028472;
	b=EKadh1oyGjjbMJQh8qJkhWFbhdXxlMiSratR4WijK9asNeWeUN7/iVYnP9YjgUsYDSWw
	 ZCQW1oCr/JF65RlqpnUfFCI8mSI2O4vFU7zQ3GVu6BGKpYznF6hXYyxlo3CyNuipRRdr7
	 huTQC9A2GYlExjbB+nw2c8md49KQu1kKiFn8+VmvaQ5eyJvqV7oQqOgVyKJ0chcokn0Gl
	 fjTwiu4LGdd8qxtLYdYtmv0mRmC7exjnKlO78Cgz1jQwY+Y5MwNe24bNCu+ivKkle13Eo
	 DhTmw3MUFbtfAFdyehxn72whuCWE4ciAYjVg75ddJmJHmAVh4E6O/NVuOmKLu93zUxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zd23Ru3sEcmLnyFrbM6uqgjsx/biFkyqT8+RMwbdl18=;
	b=hHeppS+gZa0dkL77zDuC8jqz/VofXddDy18geYZnh2RWiX44m4RtqxZvGBaRpX32ejXt
	 NN3+f1zhCWICqJZXAaw74hActJpFoPGFk8rpAUE9yHTvXHIJENeF/LD0iBAbwUyCT3sLu
	 Jp5JgfpxJPXWLZhAzshF02LdmiuvpihaitoA1cR4KbT85Wjq71P5+QStulpDegP695n+R
	 J22yJ/QICzRz28vehyPrpcMOcbdy6bpvVgWXHqQFGA20M748U+K1Dn+S7sNBd80uHyAuh
	 4yvv01n5Kd+IR6xZ/0cwC9HvA7xtLvGev1vDUA61yNBxTGtEXb8F9LGy6haSthxEzdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqTvuVfH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B08606A320;
	Wed, 18 Nov 2026 19:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZqTvuVfH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B901F000CA;
	Wed, 18 Nov 2026 19:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028472;
	bh=Zd23Ru3sEcmLnyFrbM6uqgjsx/biFkyqT8+RMwbdl18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZqTvuVfHqikk6xgWRHBkbcLFKU4xh3AEQ5QSQqiAjOBPGs6wdlfOPHxqSrHtnlLt1
	 +LY5aRO4rsml8CMw/pOrmQ9XTQfCfqZopsYpgmOo5hH7VaE1Nk8onb88FtvNM00uSB
	 3NqnYqcfwFA5hpXNG8gyIKwXSAWiynnyTua8kv20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Anders Roxell <anders.roxell@linaro.org>,
	Brendan Jackman <jackmanb@google.com>
Subject: [PATCH 6.18 2138/2151] selftests/x86: Add selftests include path for kselftest.h after centralization
Date: Wed, 18 Nov 2026 16:04:33 +0100
Message-ID: <20261118150239.556274137@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>

commit d9b40d7262a227442bf402ea0708dc94f438bb52 upstream.

The previous change centralizing kselftest.h include path in lib.mk caused x86
selftests to fail, as x86 Makefile overwrites CFLAGS using ":=", dropping the
include path added in lib.mk. Therefore, helpers.h could not find kselftest.h
during compilation.

Fix this by adding the tools/testing/sefltest to CFLAGS in x86 Makefile.

  [ bp: Correct commit ID in Fixes: ]

Fixes: e6fbd1759c9e ("selftests: complete kselftest include centralization")
Closes: https://lore.kernel.org/lkml/CA+G9fYvKjQcCBMfXA-z2YuL2L+3Qd-pJjEUDX8PDdz2-EEQd=Q@mail.gmail.com/T/#m83fd330231287fc9d6c921155bee16c591db7360
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Tested-by: Brendan Jackman <jackmanb@google.com>
Link: https://patch.msgid.link/20251022062948.162852-1-reddybalavignesh9979@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/x86/Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/x86/Makefile
+++ b/tools/testing/selftests/x86/Makefile
@@ -36,6 +36,7 @@ BINARIES_32 := $(patsubst %,$(OUTPUT)/%,
 BINARIES_64 := $(patsubst %,$(OUTPUT)/%,$(BINARIES_64))
 
 CFLAGS := -O2 -g -std=gnu99 -pthread -Wall $(KHDR_INCLUDES)
+CFLAGS += -I $(top_srcdir)/tools/testing/selftests/
 
 # call32_from_64 in thunks.S uses absolute addresses.
 ifeq ($(CAN_BUILD_WITH_NOPIE),1)


