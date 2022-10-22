Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56ED17E8
	for <patches@lists.linux.dev>; Sat, 22 Oct 2022 01:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47884C433D7
	for <patches@lists.linux.dev>; Sat, 22 Oct 2022 01:48:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="R5zwlMz/";
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GMIwnwq1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1666403292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:resent-to:
	 resent-from:resent-message-id:in-reply-to:in-reply-to:  references:references;
	bh=pgAGvtfWFBepSErNnmOiCogblep8pK7WSNMDWQtrNSg=;
	b=R5zwlMz/107juIjSzzYSuxCVBqjF8ywPjCj3mD1PNCPOm8dYgwZ2R2SNIjQbfYjLa1sovv
	g/LI2PRWWfqaXLHD40LD7+6c9Sz7zIbAxXY6pneMD+BQtgIxD0lpSxQsW3UaL7kpeRlI9S
	LuwqEDutogLDkVRln4oH0ZYLGwxIcD0=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 40fb35e8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
	for <patches@lists.linux.dev>;
	Sat, 22 Oct 2022 01:48:12 +0000 (UTC)
Resent-From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Resent-Date: Fri, 21 Oct 2022 21:48:11 -0400
Resent-Message-ID: <Y1NL2yE87QiZ2FsT@zx2c4.com>
Resent-To: patches@lists.linux.dev
Received: by 2002:ab0:3311:0:b0:3e5:cdde:6278 with SMTP id r17csp1682566uao;
        Fri, 21 Oct 2022 18:44:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM60HpzdRr2DU+XWmulmOvl1nQRbPgJXFdQ7PrLywu6qV1omFR9suxFc2j9YHnF85qjrDvaV
X-Received: by 2002:a05:620a:1519:b0:6ee:af9e:9048 with SMTP id i25-20020a05620a151900b006eeaf9e9048mr16367667qkk.601.1666403064149;
        Fri, 21 Oct 2022 18:44:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1666403064; cv=none;
        d=google.com; s=arc-20160816;
        b=vMRFgFrm+c269D+LKI2Aw+NH4T2m8sPSRbKdf0Jn4GmEx1WueHLHIdFAiou1La8mHt
         aONcLxXi/0QvgQq5ACyZNLHCI5Vy8snQJUtGXyCOnkpTnRVVMYRfE7bOjbMWmKRkUW5B
         VfaZT4b4TGS90CQbczZZyZGEaSUOXNPTRoN1C7aJTjJlgwGAGxN7slcaD4chaWFaXPYG
         xIW4aEEyKs57uGUTw5dm8G0cUw4xcEyhWH0o21cw4+UxtzMumhtXMRuJ6hVvta67hFzu
         4MmiBje9zRwF2DW2UpxuIRnS27ChuqaYByxh2xLL9/5OV4i6+MWw769F/yxvP/jDVYsn
         JS/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20160816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature;
        bh=pgAGvtfWFBepSErNnmOiCogblep8pK7WSNMDWQtrNSg=;
        b=kp67OUo2xA8EVRISltI8oPTdn+UByT9ujv4s2uZQ1yfK9eL/gklYfkN5koppc/ErLK
         yf0j45fg/8tww1PbXwoZLvh9EHbXV2h91KiZVvBEb0BWuvu3tJI0deWIiOfjzBhptmiU
         ntxEgi5fgYPWlTqNDCX9/ZW3imWzdDqpIxOrDtG7xTv3MOhwT0dnTQGiMs8yRfJ2N/4M
         WBSQHU9RN5BLkX+9GZtVFLbPFB8wMaHaMs13/5TiI7YP3PhlzYeeqcVhhtdShVR0wvTX
         fs/MPR3rg0HyawW2Mtvuy8RNZKd7NqdSBXhlxZBC7/MkXCg3RBOWBK4Gz6KBucTu7JTr
         yBig==
ARC-Authentication-Results: i=1; mx.google.com;
       dkim=pass header.i=@zx2c4.com header.s=20210105 header.b=GMIwnwq1;
       spf=pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) smtp.mailfrom=Jason@zx2c4.com;
       dmarc=pass (p=QUARANTINE sp=QUARANTINE dis=NONE) header.from=zx2c4.com
Received: from mail.zx2c4.com (mail.zx2c4.com. [104.131.123.232])
        by mx.google.com with ESMTPS id gv3-20020a056214262300b004b2718c421dsi13135787qvb.37.2022.10.21.18.44.24
        for <jason.donenfeld@gmail.com>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 18:44:24 -0700 (PDT)
Received-SPF: pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) client-ip=104.131.123.232;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@zx2c4.com header.s=20210105 header.b=GMIwnwq1;
       spf=pass (google.com: domain of jason@zx2c4.com designates 104.131.123.232 as permitted sender) smtp.mailfrom=Jason@zx2c4.com;
       dmarc=pass (p=QUARANTINE sp=QUARANTINE dis=NONE) header.from=zx2c4.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1666403063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pgAGvtfWFBepSErNnmOiCogblep8pK7WSNMDWQtrNSg=;
	b=GMIwnwq1awcpUW/3bcqRLII9Ls9FFpGfdnmMIcvGbiEtdgTfYCtyHBxD9yKHQ7iLoU7MWe
	oedm6GH5CEx+hIfF88+NdonBLSB3Qlk4BllZXEvDgVRGj4TJT9CbyQxCoDz8OaY8tqxGTj
	zGaJgSvm0ym+4US4UBRtlbzQYNmOeTE=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e102b3b6 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sat, 22 Oct 2022 01:44:23 +0000 (UTC)
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
Subject: [PATCH v1 3/5] random: add helpers for random numbers with given floor or range
Date: Fri, 21 Oct 2022 21:44:01 -0400
Message-Id: <20221022014403.3881893-4-Jason@zx2c4.com>
In-Reply-To: <20221022014403.3881893-1-Jason@zx2c4.com>
References: <20221022014403.3881893-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that we have get_random_u32_below(), it's trivial to make inline
helpers to compute get_random_u32_above() and get_random_u32_between(),
which will help clean up open coded loops and manual computations
throughout the tree.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 include/linux/random.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/random.h b/include/linux/random.h
index 3a82c0a8bc46..92188a74e50e 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -91,6 +91,30 @@ static inline u32 get_random_u32_below(u32 ceil)
 	}
 }
 
+/*
+ * Returns a random integer in the interval (floor, U32_MAX], with uniform
+ * distribution, suitable for all uses. Fastest when floor is a constant, but
+ * still fast for variable floor as well.
+ */
+static inline u32 get_random_u32_above(u32 floor)
+{
+	BUILD_BUG_ON_MSG(__builtin_constant_p(floor) && floor == U32_MAX,
+			 "get_random_u32_above() must take floor < U32_MAX");
+	return floor + 1 + get_random_u32_below(U32_MAX - floor);
+}
+
+/*
+ * Returns a random integer in the interval [floor, ceil), with uniform
+ * distribution, suitable for all uses. Fastest when floor and ceil are
+ * constant, but still fast for variable floor and ceil as well.
+ */
+static inline u32 get_random_u32_between(u32 floor, u32 ceil)
+{
+	BUILD_BUG_ON_MSG(__builtin_constant_p(floor) && __builtin_constant_p(ceil) &&
+			 floor >= ceil, "get_random_u32_above() must take floor < ceil");
+	return floor + get_random_u32_below(ceil - floor);
+}
+
 /*
  * On 64-bit architectures, protect against non-terminated C string overflows
  * by zeroing out the first byte of the canary; this leaves 56 bits of entropy.
-- 
2.38.1

