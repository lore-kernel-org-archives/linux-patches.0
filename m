Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8566917E6
	for <patches@lists.linux.dev>; Sat, 22 Oct 2022 01:48:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2839BC433C1
	for <patches@lists.linux.dev>; Sat, 22 Oct 2022 01:48:03 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="cHI5VJbo";
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ZSLnssMM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1666403281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:resent-to:
	 resent-from:resent-message-id:in-reply-to:in-reply-to:  references:references;
	bh=29Qx1OOG1bJVKU5nLBC6PT0Zulbd8r14TiIGy8T/ClE=;
	b=cHI5VJbo2hlREeAzyesKhCRDS2yT7vu9yEALp41kRNqxLRijwFqhnFx1ZSZ9NxelKnXmx9
	BmIb1PqesKnTgF3fCT/QKXCKXyl3vw7ULS0V+1X/5fyglAJjOmDWt/0tAfOOe/ysY0LRKS
	imsdR7wejhzMWWlKwivlsgNQ6+ntw3A=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 195aa3a3 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Sat, 22 Oct 2022 01:48:01 +0000 (UTC)
Resent-From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Resent-Date: Fri, 21 Oct 2022 21:48:01 -0400
Resent-Message-ID: <Y1NL0bZwqboHU73I@zx2c4.com>
Resent-To: patches@lists.linux.dev
Received: by 2002:ab0:3311:0:b0:3e5:cdde:6278 with SMTP id r17csp1682562uao;
        Fri, 21 Oct 2022 18:44:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6vRE8X4RvbcVnkBighJn8DB+hE3mqERbDEc7WEVqiIoFn5r3H/hhFPUdLu9lbVnyTh0KYH
X-Received: by 2002:a37:be07:0:b0:6ee:d079:ce00 with SMTP id o7-20020a37be07000000b006eed079ce00mr15574187qkf.525.1666403063931;
        Fri, 21 Oct 2022 18:44:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1666403063; cv=none;
        d=google.com; s=arc-20160816;
        b=KechpqOWhPC5ZYqg530NTj3Sg1eo/334sQkHb4y+grCeIhdmcsWNlyHAVJaxX69sjk
         tBM7JWjThjzisUVpMjX9dFrApgoyw9GtEK4Mi9/q+SyPsr1f1e+M00101GeLq6Ccjrda
         YlbyGw7EbuEd2+OPy4CocsL3cOO4hy+ZVXVtkpTAaYxWak6rfUPUMn/uw843TufgX2Fz
         19t2tZI3VPzYKDDl83c5Puxe2NeF8BeLlTvixhkBVwo6dyQ46PQ9SgnlSfVrjSJQkZxF
         Kn+1TAZFpdZ5qpweagTnXu5lFqZ+GJNGCA84E9obsYT7lavINqE9/njSeLyzoX3Im8OO
         TKxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature;
        bh=29Qx1OOG1bJVKU5nLBC6PT0Zulbd8r14TiIGy8T/ClE=;
        b=o+Y9Y2DADFuLKMEfgyjfI0OfajtAPJaB3apSJdZktnZZUqioVzWN3baYfsRnWJZd2R
         8t0/IK4n4DKcM28DlZO7gTsE6JBniFORFQ5fwNtYBTYHkUXhrX/GFN/4rkCgG8l4ugxY
         KPceQniUmcmVyM5Afu2ZD+88h9exl94ITY2VgoiStbMwgH5gjiR77yyF4a8hL+bnogpg
         nRbvejveroDqKy+YdZ+1VPvKnTe+hVgZmg7BPdrqama9hyVKPRVYzm9G5u8AGgFsICAL
         Q+qO+3hnoHqfUXqUSllcHG4NSEbZ/2QskSD8P1Vp5a3il2+aWFF2tOrkJDz/jd4AvhyS
         TTiA==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@zx2c4.com header.s=20210105 header.b=ZSLnssMM;
       spf=pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) smtp.mailfrom=Jason@zx2c4.com;
       dmarc=pass (p=QUARANTINE sp=QUARANTINE dis=NONE) header.from=zx2c4.com
Received: from mail.zx2c4.com (mail.zx2c4.com. [104.131.123.232])
        by mx.google.com with ESMTPS id gv3-20020a056214262300b004b2718c421dsi13135787qvb.37.2022.10.21.18.44.23
        for <jason.donenfeld@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 18:44:23 -0700 (PDT)
Received-SPF: pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) client-ip=104.131.123.232;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@zx2c4.com header.s=20210105 header.b=ZSLnssMM;
       spf=pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) smtp.mailfrom=Jason@zx2c4.com;
       dmarc=pass (p=QUARANTINE sp=QUARANTINE dis=NONE) header.from=zx2c4.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1666403062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=29Qx1OOG1bJVKU5nLBC6PT0Zulbd8r14TiIGy8T/ClE=;
	b=ZSLnssMM0XXH+M9MGOvoehNy19YdOKzTX6iGl0UHOqI4RWMitRvRr1WskqdMj90Ml9VLrJ
	IuhsEuEmVy8Qa+CESsXjAN4xPt6P8dHKXQt/9Pr9gQfngTcBY2HhGL5NsPrr+AQLmBIcrW
	/z7HeLfTwAnxeups3mxxZjvOWG4zu2Y=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b3ec9f35 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sat, 22 Oct 2022 01:44:22 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Kees Cook <keescook@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	"Darrick J . Wong" <djwong@kernel.org>,
	SeongJae Park <sj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Helge Deller <deller@gmx.de>,
	netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-mmc@vger.kernel.org,
	linux-parisc@vger.kernel.org
Subject: [PATCH v1 2/5] prandom: remove prandom_u32_max()
Date: Fri, 21 Oct 2022 21:44:00 -0400
Message-Id: <20221022014403.3881893-3-Jason@zx2c4.com>
In-Reply-To: <20221022014403.3881893-1-Jason@zx2c4.com>
References: <20221022014403.3881893-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With no more users left, we can finally remove this function. Its
replacement is get_random_u32_below().

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/prandom.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/prandom.h b/include/linux/prandom.h
index 1f4a0de7b019..8272c08f3951 100644
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -23,12 +23,6 @@ void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state);
 #define prandom_init_once(pcpu_state)			\
 	DO_ONCE(prandom_seed_full_state, (pcpu_state))
 
-/* Deprecated: use get_random_u32_below() instead. */
-static inline u32 prandom_u32_max(u32 ep_ro)
-{
-	return get_random_u32_below(ep_ro);
-}
-
 /*
  * Handle minimum values for seeds
  */
-- 
2.38.1

