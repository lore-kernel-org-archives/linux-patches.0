Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31BF2367A0;
	Wed, 23 Apr 2025 15:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421345; cv=none; b=kFjxd9bWd2yBlvti1z4WOlHKWFqwhrt/sIc489o0xjBj4PPjRJYhv0ctMy0xl9eceX4JDsE5QDpAIZ2JMvrnxkkkQ7Hxo1n9Xr36fd4Jrx+imWIr6l/pW6hghyH4UksIZ6g0PZzUemlR3DRp38tuoAV1lcBfET1k5ndhh4sICjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421345; c=relaxed/simple;
	bh=Br7bXxUiRnXwUKYmkevGa5rGM2tAvcBEsmZtFZ3A55E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ady03NQK+Ihm6kyByP1Ct9KxB6hdTaULrokiIP2Yq9GC4D/NJOEoayOHmFHXIm62Vy6VI4pNgqK+cKU4nLZuxa4C5UpvkIKNQIt2pXOOIeH2gBvMhOd3e1SZcmLQ0O6tVEInKhUdjCN/acXW9tlLzlN94/qqoNc7aeXV5v4LioE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFyjlXk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFyjlXk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557C3C4CEE2;
	Wed, 23 Apr 2025 15:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421345;
	bh=Br7bXxUiRnXwUKYmkevGa5rGM2tAvcBEsmZtFZ3A55E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFyjlXk/2c++zU88d7Q8spW9V6wZdjndWPDQ3rsejWBMXhV8PODyatKgPYg2PE7z+
	 c6v658IdqNwklQAlYTQN7folkMCEbvPND3DA/HcN8xRyV9uSv/Ne0ZJVj+gV74iA2P
	 rebbJXOeSBCohS51EVsPFzn6idK2kAlykE9KZ4S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WangYuli <wangyuli@uniontech.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.12 213/223] MIPS: ds1287: Match ds1287_set_base_clock() function types
Date: Wed, 23 Apr 2025 16:44:45 +0200
Message-ID: <20250423142625.836517720@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

commit a759109b234385b74d2f5f4c86b5f59b3201ec12 upstream.

Synchronize the declaration of ds1287_set_base_clock() between
cevt-ds1287.c and ds1287.h.

Fix follow error with gcc-14 when -Werror:

arch/mips/kernel/cevt-ds1287.c:21:5: error: conflicting types for ‘ds1287_set_base_clock’; have ‘int(unsigned int)’
   21 | int ds1287_set_base_clock(unsigned int hz)
      |     ^~~~~~~~~~~~~~~~~~~~~
In file included from arch/mips/kernel/cevt-ds1287.c:13:
./arch/mips/include/asm/ds1287.h:11:13: note: previous declaration of ‘ds1287_set_base_clock’ with type ‘void(unsigned int)’
   11 | extern void ds1287_set_base_clock(unsigned int clock);
      |             ^~~~~~~~~~~~~~~~~~~~~
make[7]: *** [scripts/Makefile.build:207: arch/mips/kernel/cevt-ds1287.o] Error 1
make[6]: *** [scripts/Makefile.build:465: arch/mips/kernel] Error 2
make[6]: *** Waiting for unfinished jobs....

Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/ds1287.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/ds1287.h
+++ b/arch/mips/include/asm/ds1287.h
@@ -8,7 +8,7 @@
 #define __ASM_DS1287_H
 
 extern int ds1287_timer_state(void);
-extern void ds1287_set_base_clock(unsigned int clock);
+extern int ds1287_set_base_clock(unsigned int hz);
 extern int ds1287_clockevent_init(int irq);
 
 #endif


