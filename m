Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951F279C0
	for <patches@lists.linux.dev>; Fri, 23 Feb 2024 00:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708649908; cv=none; b=ZL7Ock4+ei9LKvZ2PiiHWFoxZiei7K4672gASqsTm9Q2PSql12nvIFD1nhBOPkkpaBe19i//Z7YCpr+lY5isn1QLAnfVIzhD++cH5GUBzXqfpe+dqD0TAlKg0FH2EPLn54/MxFCCos7LEHWZK60Cx+/8kGj87PViapUjWy22yEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708649908; c=relaxed/simple;
	bh=Yv95oUBVwHL+klTlaf4CCrT0NDQIAhnk1AXpEBUeoPk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=arQk2s0RD+MbIOikxxvb889cinboprDUVhkzkYC/Pgns53XQT6SteX2hniGb4+//p2s1/Owdy3NwJbYu0GBKym2k/0TVo7Vk35mrhpx6xQip24CFNRg5GA5Wd+K6kI0ZcuHVtXfs3QN1+F6glZR9cov+n878U6zVboa75h7z9hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Y9qeaA+o; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Y9qeaA+o"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1dba94f9201so3600995ad.0
        for <patches@lists.linux.dev>; Thu, 22 Feb 2024 16:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1708649906; x=1709254706; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VH1NzkyIM1modeMDErSW1HbJ8OWRHRbFLTDFwTFDzDU=;
        b=Y9qeaA+oHCb3xDD4lYy+Ej139yOyablYZ6JrZaK4AmAUC3KwMKxgMB7uJMXJ9wclxS
         HIUNs2ar5tlIe/3WLzUFbez0lEn2YweaXAy7ipPzVN7ulMJaT+7NVUt/cAUeGRK/USwr
         zPONB5Y3fvF7LszSgqP6EKC5yce+MPyEYkRHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708649906; x=1709254706;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VH1NzkyIM1modeMDErSW1HbJ8OWRHRbFLTDFwTFDzDU=;
        b=KdUqOczwP/qKRanQJrpRAuip2pbg8ZYohIYaiWX80FIhJigwFE6zyP6bF3GEbUhyRw
         losww1uzruwWhkcfM2D94Br0X+4Y4Bsd11ERy+5wGv+DcUgleXEgL0e3rET6DXRl7OU9
         aXuxsDJvzjtSIabaOj2MVu+mYHHmVo9MYuuPrGA4USXzZmvawmEu2n45H+KhCXTYr9pN
         pqPJZm4Q8f+gaSzUnRMKaHnhDseZP7uoBb9T+XQGeaExLyLblf24qjv+7eoT1rGZcLm2
         Y7Hg7dG07BRRO0aJ9o9VW6Z4gK0FP9Jva3/BA5hT5zTQnhzOIP3gjEOP+i2uJj/2T2GC
         rSow==
X-Forwarded-Encrypted: i=1; AJvYcCXeBTeWR8CsxdOBwPH+xFLUvNjKd4jOIKrdgP+NwL6aUIGjkofEgJT70RhzaCTYiL0ces4QWqnrIepGffD2zzgCjnfDlevy1w==
X-Gm-Message-State: AOJu0Yyegc7MB7Eo3jfqwAIqI0olr4OrLcrziALmVH9Dh0UUphkK++JZ
	SqNTa+uTUsOi2FSQ8c8Ss8WkdEZnZkMhhoc2lEWHpVkXClrcR/C4M3PrgjrOSQ==
X-Google-Smtp-Source: AGHT+IGjICwwii411i5LHahgISzEk+LobyYJRnh5mg9ED9u8VN/9jZjDrPw3Ji8R+rBKg1J52mcELQ==
X-Received: by 2002:a17:902:a98b:b0:1dc:540f:c5eb with SMTP id bh11-20020a170902a98b00b001dc540fc5ebmr418354plb.51.1708649905814;
        Thu, 22 Feb 2024 16:58:25 -0800 (PST)
Received: from localhost (175.199.125.34.bc.googleusercontent.com. [34.125.199.175])
        by smtp.gmail.com with UTF8SMTPSA id v11-20020a170902f0cb00b001d937bc5602sm10528250pla.227.2024.02.22.16.58.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Feb 2024 16:58:25 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Rob Herring <robh@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	devicetree@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	Herve Codina <herve.codina@bootlin.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Roy Luo <royluo@google.com>,
	Conor Dooley <conor+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	linux-usb@vger.kernel.org,
	maciek swiech <drmasquatch@google.com>,
	Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v2 0/2] usb: Set connect_type of hub ports based on DT
Date: Thu, 22 Feb 2024 16:58:19 -0800
Message-ID: <20240223005823.3074029-1-swboyd@chromium.org>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is split off of a larger series[1] that describes the USB and DP
topology of ARM chromebooks such as Trogdor (sc7180-trogdor.dtsi). These
patches can land at any time, so I'm sending them split out to hopefully
focus review and land them earlier.

The first patch updates the realtek binding to describe the downstream
facing ports (it has 4 ports). Child devices can also be hard-wired to
the hub, in which case the binding allows those devices to only have reg
properties with the valid port numbers (1 through 4).

The second patch sets the connect_type member of the usb port to reflect
what the DT binding indicates. More details are in the patch, but the
general goal is to set the connect_type based on DT so that it can be
queried by userspace in sysfs. ChromeOS wants to know if a usb device is
hard-wired or not so it can apply more or less security to the device.

Changes from v1 (https://lore.kernel.org/r/20240210070934.2549994-4-swboyd@chromium.org):
 * Moved the code to of.c to keep it tidy
 * Updated the check for child nodes to only be for usb devices or graph
   binding in case of things like HSIC where a child node 'ulpi' could
   exist
 * Fixed the binding to have #size-cells and #address-cells

Stephen Boyd (2):
  dt-bindings: usb: Add downstream facing ports to realtek binding
  usb: core: Set connect_type of ports based on DT node

 .../bindings/usb/realtek,rts5411.yaml         | 55 ++++++++++++++
 drivers/usb/core/of.c                         | 71 +++++++++++++++++++
 drivers/usb/core/port.c                       |  2 +
 include/linux/usb/of.h                        |  7 ++
 4 files changed, 135 insertions(+)

Cc: Conor Dooley <conor+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: <linux-usb@vger.kernel.org>
Cc: maciek swiech <drmasquatch@google.com>
Cc: Matthias Kaehlcke <mka@chromium.org>

[1] https://lore.kernel.org/r/20240210070934.2549994-1-swboyd@chromium.org

base-commit: 6613476e225e090cc9aad49be7fa504e290dd33d
-- 
https://chromeos.dev

