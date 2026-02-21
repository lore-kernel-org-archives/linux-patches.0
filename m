Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54DF1A58D
	for <patches@lists.linux.dev>; Sat, 21 Feb 2026 00:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771632988; cv=none; b=cJsIIE9xGhX0iGiWSshwiBA8drd1JK7ozmtTUOq0ka3XBfhpBMk+VvWc0Q/m7F+uzC6koBdZZYGmFPmeSCeVT9d/qx5qYTnT2HerRbwpcdWfU+R0lmgjV4LRrK9MVTcZfIwswPITnC8Xy2o0EOT2dsDy0rRWAfZ62mKZtiSUFz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771632988; c=relaxed/simple;
	bh=3CyBu6t4VMRW7+VaTdEqeBQZt8ryLT8L+AYTjT70+ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n6Oq8ef4PAOwMDtshaEjMxNpCWekvhRBQHn6cz2DWsFPlXxfp4xlC0nUqgO47HgQTH3WQEjyY5RUdEWHbRG7ixHi878IkMVSzp31RAkcWtkybf4vYvw14133YmrcHjASTavA5+5a6MOpxLwaGLGwez7OtRLT2sGvocbWNnaXHuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JEPcnR06; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JEPcnR06"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48375f10628so15923985e9.1
        for <patches@lists.linux.dev>; Fri, 20 Feb 2026 16:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771632985; x=1772237785; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pT8043eXb3x0Y28ESC3KU+eLsSvxZ0GN6RPVeedqxFo=;
        b=JEPcnR06XRRc+k2qmWpsci0CKTSJAqbi82qumeSY+jPyRc0+89DwjXOf6s1y8NLUaC
         iFAVv09MJZSeUuBoXzokRw6tHJrQRU32F84omtv+j2/2YVgBhsKHhn80MSarbQ3VBOEc
         QvrlPTFyUfdkGo1WFqS5tAQjhxiu5QheV7q3f5hYBXqYILAGYA3hEsEmDg+yzabxqiul
         ekA5w1DCmam6Y+S/UEaRd8fXF0ULK+QGhSfrDjlLPghFwIcT/Iy0wp7dUrpUDcPLZ1oX
         jAtfZvoIuTFYiZi4eBM+U7pozeyyYqbx0kEReX68dAw9ciIvbYn44k6W3qddgqw/lwRJ
         Kxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771632985; x=1772237785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pT8043eXb3x0Y28ESC3KU+eLsSvxZ0GN6RPVeedqxFo=;
        b=Z5vphqbx/82UyxrVe+dX7p7SBqKqI3/NAZ5BsifYXMrbJ0vhF33EuqAjeqJSsbHnVj
         yAemCBRsu8Mpg9QqYLt4FKJMEv4CQn8EoojTxH2wu+BV9r327NVAxhH4VvMO76b+0GiM
         P2PGB89HkSsEdbu69vanMMYbocKQsi0SIG/1rJyKQt05VWxp8JJuwZgwel0BY8dOLaK1
         Bxkne4gjk5OSf+qPEJJVKYaWXjH7qRc6KIplE/syDW6W8Thtvf/umBNmaWHTT5A7kX/X
         j4FKgo/R4Fe5Fl2uFU4q+Oa70d1PoGRRKy0EgHKVZ1ZD/MyGLsFjVlNBF9grV6RqgHYO
         NzlA==
X-Forwarded-Encrypted: i=1; AJvYcCXQdyTj55sRQMLLIo5vhSsUyTSelqOm5DcNIsAPgEOHJ2i4e92fZSAoPa9wsfQmLBk6NDF13eRc@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6Rtf7rmmh9fGfznLKQJdzp/ZJGz+8vVMv8KA1hiMIG+SQS8rP
	yGAX/DUfdAAszyd8/L69MLhTxpqi94XtwW9UAS+eNZJLfCjkb4m16lXr
X-Gm-Gg: AZuq6aL983lH7HO9AJC6eoG/KA8wISrJM9qu/b9WY2wkuBuyOauFFYKrX6GGHwQCIxa
	XS/gaenCG3HGGWo/maeQjKYdkcQa19MSZ+6tMF4r2gd+TyIXHCdgQRLsUClbwj8Hlqzikw13klr
	RIjmjpn2g7ttXPpfalD97o1DVQQUNoycrqqXr2NSBnsYx38f6f8MyxySo+/6BJQwk4CFnILIOHR
	/slSSfVw+zXEX0WGvrEZ8JqO7+8j3FftdbhcV6r5Y/VaoTJutG0tVqPuREr9QRTMxjJInuTRoU5
	NCY6lCb/ePcdEoIvK8Is0uPH7WaLv8i4YZXSX5xkC+gG/STRk2VwzUXZQHtDWXFkW2dHhDp7Ps+
	lMK0D9WymgzMxjs1EKG3w5tbHAv4ZSx/PHJqrGJ0ECzUhX4XXuhGq1ZWoOEwxLMOhKOI03DW2xG
	pLodxmGJOXSBxetIql5O0=
X-Received: by 2002:a05:600c:1d15:b0:47e:e8c2:905f with SMTP id 5b1f17b1804b1-483a95bc0cbmr16930615e9.8.1771632985095;
        Fri, 20 Feb 2026 16:16:25 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-483a42cd49fsm38764515e9.5.2026.02.20.16.16.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Feb 2026 16:16:23 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: ddiss@suse.de
Cc: brauner@kernel.org,
	initramfs@vger.kernel.org,
	jack@suse.cz,
	linux-fsdevel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nathan@kernel.org,
	nsc@kernel.org,
	patches@lists.linux.dev,
	rdunlap@infradead.org,
	rob@landley.net,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/2] init: ensure that /dev/null is (nearly) always available in initramfs
Date: Sat, 21 Feb 2026 03:16:09 +0300
Message-ID: <20260221001610.820321-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260220112606.551099f5.ddiss@suse.de>
References: <20260220112606.551099f5.ddiss@suse.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

David Disseldorp <ddiss@suse.de>:
> It looks as though Bionic has extra logic to handle missing /dev/null
> during early boot, although it's dependent on !is_AT_SECURE:
>   https://cs.android.com/android/platform/superproject/main/+/main:bionic/libc/bionic/libc_init_common.cpp;drc=a7637a8f06f103c53d61a400a6b66f48f2da32be;l=400
> 
> I think this would be better addressed via documentation (e.g. in Bionic
> or ramfs-rootfs-initramfs.rst).

Okay, I see, current bionic behavior is good.

Okay, I agree that this /dev/null patch is not necessary.

-- 
Askar Safin
