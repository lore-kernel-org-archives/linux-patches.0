Received: from mail-oa1-f66.google.com (mail-oa1-f66.google.com [209.85.160.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DF31D220A;
	Thu, 24 Oct 2024 12:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729773278; cv=none; b=od3BG9JcW7+JK/u6cze9nCsMRjcp3sKsN2RX2f98msfGLBlf7quZh67qGMabaCVL52p1nHLCJez80H33YpWG6l87wAqpX7KCkCrxEQP+LvSbv9F8S60ct+ub/E+f5Hyc1FDI9PCNCSdNsNizmByrvaNxONgKX7d3vmH6cW5/6k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729773278; c=relaxed/simple;
	bh=WqKO+VQufYnnSQGNsjJoV9pHpcM4NLycUTcWyfMcgg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfFby7ktPfaM8Je8ZJnyk8skBpp7XZRTCl0OqQC88l6642lhOF7FcfDcgJd+zNUZQ4rB4108yO0VyGZYa3CXHToQZTItxSK0bg1D3Ns8W0bPHGykElhta433X8w+U3+LcLnK5c7UnAkc7FMM5uLjQqkkZ8uIj86y+CtQTwkIUPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k43UCJhS; arc=none smtp.client-ip=209.85.160.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k43UCJhS"
Received: by mail-oa1-f66.google.com with SMTP id 586e51a60fabf-288d74b3a91so546695fac.0;
        Thu, 24 Oct 2024 05:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729773275; x=1730378075; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WqKO+VQufYnnSQGNsjJoV9pHpcM4NLycUTcWyfMcgg8=;
        b=k43UCJhSc08xpUVw4thwBUskmOZIpBdu4hXyP8MAFjmGhVAv6g2qM2qoZfnaftAHan
         hjO3wHtlLbc7rb7UsBVBNutCX6JGzxP4An4lfNZKryRrOKsWuYgKKs7UTokJuKKqAs2y
         N8Ddt4Ic0Hgq3LmpX5/h4/e7C/vdQ6+12svDMQW0SGBpo6U/3eH7gPbM5xma6kQzJOEP
         T6M9sSVLFb14ssjc3zRMtDqeSA6KoAO2Y0Zvqjo1tqIC9laNZleXXL1l9Qa/0tNr6ixQ
         9huE0mYPaf8XqLlgncCv56PCZd572LWF84pZkpXyr3ET8JI5hRlfyODt2tc7w0qQDrVJ
         O23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729773275; x=1730378075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WqKO+VQufYnnSQGNsjJoV9pHpcM4NLycUTcWyfMcgg8=;
        b=POxSX1UkNYkLCD/xb+E0n+PWufEAdDw0qFDChFlfGJp7/WVI+4itg5g7UMcM3Nb7kH
         p+/4/cU4nX5v1X93R/DYM9yipa7S/Eba3++EMUjQpIGWsfPXNyyY8R31RYh4R3DQihDw
         YDPnc7qRK4jyf2QJg9rc9b0fxVMId8jFJdjkuRa0kifQMErc0qbnF411aB5sIbuesIja
         knfmRnHlMqn881v0nK1fANVhLvrQVH91GZsid1iRrmO8ZSI7Fi0kFyr0iAjW8ngGWTDg
         4HWVFs1MkWhf8O5Js0s90L//I28RRgGm4hprfFCwnsJp+z98SJiEd+ZpICTN+ktZJtsQ
         mYig==
X-Forwarded-Encrypted: i=1; AJvYcCVVZlE8rG4sAGtVAXIJ+kJdpssEUocvdGZ+2pdAIoXf6PGhq2IjH8aRdwwcUv7aW+G2eFs=@lists.linux.dev, AJvYcCVfGdaNXCIdac8q9OvIVfeqaoqrJpMU/1B+di/cPOky0RmYAcKiy8gnsnbJ+ANMGKepex7GHN236Q==@lists.linux.dev
X-Gm-Message-State: AOJu0YzSnoB5iGohbeLN3AM2sdCv0q/CZ2rYhv4L3tys/+Rhv3osM3tx
	NZONfNdesWKd7X1Ki5/Ss++EOPyt1yYhJwSCJ7nPte3JXzyhOgX6
X-Google-Smtp-Source: AGHT+IGNbdDr4bWOuekBU0ohovYD+u0SLmOKefBPtfh2fzqlR42/5wZYBu+ZqeJfv789Y4nUSEsYRQ==
X-Received: by 2002:a05:6870:218a:b0:277:fb59:b74c with SMTP id 586e51a60fabf-28ced48efd0mr1364818fac.40.1729773275318;
        Thu, 24 Oct 2024 05:34:35 -0700 (PDT)
Received: from localhost.localdomain ([114.246.193.69])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7eaeab48f62sm8534093a12.42.2024.10.24.05.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 05:34:34 -0700 (PDT)
From: =?UTF-8?q?=E9=99=88=E5=AF=92=E5=BD=A4?= <cxwdyx620@gmail.com>
To: jensenhuangnvdia@gmail.com
Cc: aospan@netup.ru,
	conor.dooley@microchip.com,
	ddrokosov@sberdevices.ru,
	dmaengine@vger.kernel.org,
	dushistov@mail.ru,
	fancer.lancer@gmail.com,
	geert@linux-m68k.org,
	gregkh@linuxfoundation.org,
	hoan@os.amperecomputing.com,
	ink@jurassic.park.msu.ru,
	jeffbai@aosc.io,
	kexybiscuit@aosc.io,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-fpga@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-iio@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-spi@vger.kernel.org,
	manivannan.sadhasivam@linaro.org,
	mattst88@gmail.com,
	netdev@vger.kernel.org,
	nikita@trvn.ru,
	ntb@lists.linux.dev,
	patches@lists.linux.dev,
	richard.henderson@linaro.org,
	s.shtylyov@omp.ru,
	serjk@netup.ru,
	shc_work@mail.ru,
	torvalds@linux-foundation.org,
	torvic9@mailbox.org,
	tsbogend@alpha.franken.de,
	v.georgiev@metrotek.ru,
	wangyuli@uniontech.com,
	wsa+renesas@sang-engineering.com,
	xeb@mail.ru
Subject: Re: [PATCH] MAINTAINERS: Remove some entries due to various compliance requirements.
Date: Thu, 24 Oct 2024 20:34:03 +0800
Message-ID: <20241024123403.154-1-cxwdyx620@gmail.com>
X-Mailer: git-send-email 2.47.0.windows.1
In-Reply-To: <20241024113246.22901-1-JensenHuangNVDIA@gmail.com>
References: <20241024113246.22901-1-JensenHuangNVDIA@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Well, the fact is that Linus Torvalds, our leader of Linux, is not **Palest=
inian** but **Finnish**.=0D
