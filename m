Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6139A3B6C09
	for <patches@lists.linux.dev>; Mon, 15 Jun 2026 20:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781555228; cv=none; b=N6S+ulNWUKm5KbXNq2OksWSeGaV4S6Sz7ZJo3DIYzAX0/evidH/bPS6l4RJmxg/sMo+JG3iB43RWp9q+r75EcrgFhUXxuCJsMNWE3E/5kfSy0zucqjTdl0Vu7KIBSEFPMdUZLfbTDefPF9OruHlTyHPgsYBp/NVEWfQLGiJ9DNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781555228; c=relaxed/simple;
	bh=L6uPFRUuvFSNX8q/A2FKlrgoQUCrS0/ehyc31oklwz8=;
	h=Content-Type:From:To:Subject:Message-ID:Date:MIME-Version; b=bwzr/Tu21iU9N0VJ3QairxrpMc00vL2BtCfWzzT+YBSzMXjIbCJnKMtKx9/q2+BoUX4C6k3lRi1f/aOWFHdMeCsL8CODonJpXx7AYbWo960BE0G35gzJmeZrK609rrycmWlsmc2LxIoh87DSjM2UgdrdHBEJw5tcB167UbS+bxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ug+T7xzx; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ug+T7xzx"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490b613a17bso34594325e9.3
        for <patches@lists.linux.dev>; Mon, 15 Jun 2026 13:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781555226; x=1782160026; darn=lists.linux.dev;
        h=mime-version:date:content-transfer-encoding:message-id:subject
         :reply-to:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=L6uPFRUuvFSNX8q/A2FKlrgoQUCrS0/ehyc31oklwz8=;
        b=Ug+T7xzxUDzaoz4O5AesJID54Nvgz+HCZyDC5CmlGhg1k5MqYxZamSa15/XaFIejFR
         keFx4JQyArrVqEcZZCxdrjrkR4SDX74HLoGBDjNfMexUuZC6qp3I/5TBqukq6TJuUIjH
         +sOLgQOUTG1vK1f42IXHZ9jTT2jrfSckL2Mmextaho3F+e8YL0gsXJCg9yr+4OipYCXT
         +pW+AzCBAjP9bhzdwuJPl+cxGzwWxKjmDWBHhSog/EYiEEn7mJwyhfDKpBDaxoyppfG6
         nHDRyhmYV5DfJ4WaDNXI/GKBOoVhUwmqXupiBOLTDqy2gzC7w3XN/cHxQH+Loy79LXR6
         H3gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781555226; x=1782160026;
        h=mime-version:date:content-transfer-encoding:message-id:subject
         :reply-to:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6uPFRUuvFSNX8q/A2FKlrgoQUCrS0/ehyc31oklwz8=;
        b=L5Z+E2+fadfQgLwniRcdgDPuIvQsmOvFMwSbSdNJyroG/EC9gUyzTys2ZAVaiKGkp8
         g3OcGYXvkdZduh7M/buaTWMrdRAfY6sYdniay4PovztNiILKfrmOoflfXDcVs7/uYMGd
         5uVmLF1xGPT6LEzOwQ8l6veeEb7tl1WyPJyrpA70uBGAZKkxc/LVwkHknlenpI9eCtdK
         cEjhq7Vp7YJrz5F1xHM6XMHrW6HKs93frjB1EXs1Pe0fsun0eM6lxvmRnTqDd8ULknDS
         E3bKKp27iYN9X8IWkwoQ+0t7Y+kAwGcQK6427VD+9A9u6++NyMM19rysPpErFeu2+o58
         NBVQ==
X-Gm-Message-State: AOJu0YzP9AwJO+vg5ZYYSDEV1Jk01EkoWOE5n7vi4iJikRM8YIXWiWUz
	UVsw3x9+WoJb2/2KiusqgbOZ2trKrQP5Jd7MtZ8ZWdfk+duENQ/FgxRLE17vMErXu+w=
X-Gm-Gg: Acq92OF5PhcE9fbFiVNYDQLYl5h3XXJDPS4Vne31O8GBH2skaEx+EGBZDanpQvXhz2F
	qiiGasVpdpzxZQ12nwRQXSkkvl8U6LC9/XM6YToP5wbogbjqfg4EegcAY1qIR1OTCK0mskNl0fj
	4qOX3WJK9Sa9YHO4j1flJU51vJ3MVrYoG/QVDYgLLH18wDwi6s4NiKAwgab4t0S6TQo8Iy+kL+4
	mEKsEz6TyFoAK2ZSlr7FMCSNazKdQyDdiq+PkUl15A3yGjrsUSTTLE3VFqGF8GDcS4pnAGyDBHc
	bo/U2shY4VxLeU4eKfEL0AOu78DWTlvcMD5bacmNSc7cndoyw9/DA1lEtiAAoxChpIm/NcGrKtd
	coH5e9axiL6o6VFa8WCqEzKmzcTZOm/+oen3bkuxjLzsdtPoUGbk8ry7PJ7nDcDG06BqtCZyHG/
	7MHlnAf0v8y8jnMtrXLsg2Q0bBH80ToN38mg==
X-Received: by 2002:a05:600c:a41:b0:490:44eb:c1ea with SMTP id 5b1f17b1804b1-4922ffaf7e7mr11028225e9.24.1781555225594;
        Mon, 15 Jun 2026 13:27:05 -0700 (PDT)
Received: from [127.0.0.1] ([154.81.235.5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4922fa51440sm18582815e9.9.2026.06.15.13.27.03
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 13:27:04 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
From: Garrison Michael <dorawolfe803@gmail.com>
To: patches@lists.linux.dev
Reply-To: garrisonmichaelces@gmail.com
Subject: Project Takeoffs
Message-ID: <409a0746-3789-9321-3ecd-ee3c087de663@gmail.com>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 15 Jun 2026 20:27:03 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Hi,

At City Estimating, We provide precise takeoffs and cost estimates for=
 all trades, including Plumbing, Electrical, HVAC, Concrete, Drywall, =
Masonry, Steel, Earthwork, Roofing, Flooring, Painting, and Carpentry ETC.

Our estimates help contractors bid accurately, reduce waste, and maximize =
profitability. Want to see a sample of our work? Let=E2=80=99s connect!

Regards,
Garrison Michael
Marketing Executive
City Estimating, LLC
