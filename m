Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9155E3CCA02
	for <patches@lists.linux.dev>; Tue,  2 Jun 2026 23:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780441669; cv=none; b=V/2eSpwSVv9jDEgNqtXisiC2l1E3+5U8vDxEIP/cFP7ixVFxDex552i817EHX3VSJol9oNOW/YpoUg/B/yWLqhPiRW0l05D1XVW3INAbt5tGPWgBD/RM8jM8OYZ0+iv52tBZjshQOfmRBVm4Y8ETInHRMTHveuCKkTZzYboNs10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780441669; c=relaxed/simple;
	bh=5chq1ZYL6r9BXlem4E1EUr+5R5J1k5Q21LCWXDRISUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCC1hOjqG+o756LTgjvfhjidXKpoK3F+uHJ0RqRPS/0nNySufaMSxksNj0pBiqwX2hqCn4uTQTQA68xKMP/sMc8hdpMO2ehrkd+PjtJJKhu7ltSe8KwnbL3ldE3Rdk+0rz7MUj5cq04qGsjsPTPM0bwrNtZ/2etcN/uvlTcAmBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HVS8GzIn; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HVS8GzIn"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4903f7a90d1so109384185e9.2
        for <patches@lists.linux.dev>; Tue, 02 Jun 2026 16:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780441667; x=1781046467; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IvSaS68IPr55Kp5FHpvrg0n0LohiEL0S8pivrepEpA4=;
        b=HVS8GzInxqDSuotQjKuVYdaSikZXirtY/Qq51WsIiN0j8Yt5t2YCIu7QV9GPzp/AKG
         gwjup3PZNPfmqCQrRzjyPpR8vK1nzWpnMfQVOGBW1SSzPlHev/MNrCtCkP/1FJ7fyYm/
         nznJ3wcLD085HDKZoXKlxTIac0x+n/IhSTyju/eb3t7uXXZs6FeqCSser3BRvtdYKzZ/
         STq/0dJrPqUV3ihNkp14YqA8dEP4BZ9PwJmjArD9xfmS0Bs2IbPZqhoA/cdgca0LyPhV
         fJ6acXEQKbHDVnAL4DpjFBQHAqMcP6BsJ/Zdy2SJE0L8GPGttHujzJvEY4NqUukIMUHN
         f3cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780441667; x=1781046467;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IvSaS68IPr55Kp5FHpvrg0n0LohiEL0S8pivrepEpA4=;
        b=SRkScMygKlgwtn/YrT4ZOyPjlJVredASLkO8tiEttubTjM+4uMHwpQnIoPLX9J4WLF
         3ebIrkhgIOalUfCQgf8Qc+rNCFAROmMxl/1/akemTdFcKq48YjRC20Va4F5p+dmOWOaB
         ECcl6XSC7oL6Zf4t25IOG1g/z5qBCfon6FBCWPsszDnyyyyFCnQx4+dPQ+K9qnZv9NuC
         2yaKDHv9oYEJ+i6pmreiPL4vF8hLqCy+V0IlXZD/1Fv/8hXrWYHbX2qBkNMPEE+7cn3Z
         uwk4eUYcAA3+dE68H5KImt1YhY8mKSI5qnMWNs9y22aVYpeWhDu9OnfmUTBt4nefLw5J
         jIEA==
X-Forwarded-Encrypted: i=1; AFNElJ/UTnagu/E60089DSzwWEFo3zvLoPZ4qbnwr5ZaLtJT5tbN0EJo0QEatMsnEpRU5GmsOvfBg/31@lists.linux.dev
X-Gm-Message-State: AOJu0YybW3WXhMFqYe+uam5c6cqf1/FeLeW+kIM650IQC3VyX1MYXfbs
	5FdpZKNUsDcyZ332ZVtTDD8pHFY3b7u//Xj9vL3it/XTMalDM7wgMubc
X-Gm-Gg: Acq92OHQ1qzqu02ZRDMu1miz+xxJVfDEPSh/Dg1CMbNoo4uNRAD6FAKJdnUaX38c+Z8
	qN54HdpHQe3V7WzFWGgbjD9QHWZ0yYzjKIHPQmEmlnnFQX+nXy8bOmBxSELwKPDSStQxZf+v19J
	MbRS5rbiYIQtrnaYmI5I8ua2OC8GqRBbZBawWZx2K85AtEScgD9cjbagMWYz+EFqjmLKIAHMeD+
	4a2BzMtCNaP+gEI/DSVXECJ6sli/1pK3sO5E8cNrQK9zSQBELOXZsCNjgOhBTXVMmYfyC3kqLsq
	XN1+ls0ERBFiXQnP5forNnZR0goQk+WbqWdp9YWzNKp0vLc0/VUAIMmdSHpIqBcJOEfJUKd+1c4
	9iQRddtNCb2T0P6bPpMm8PSsW3qwQ6oPKXrJD8adjF3LVkToSMQdeTEF24j0P05ABSWvZnSmFO3
	+8HMTWuFBQQroo5NMoYWnEnMPqfxIhfXwF+h5ouFJt
X-Received: by 2002:a05:600c:698c:b0:490:44eb:c1e7 with SMTP id 5b1f17b1804b1-490b60fdd10mr11320095e9.30.1780441666946;
        Tue, 02 Jun 2026 16:07:46 -0700 (PDT)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-490b7a71bb7sm357295e9.10.2026.06.02.16.07.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 16:07:46 -0700 (PDT)
From: Askar Safin <safinaskar@gmail.com>
To: pfalcato@suse.de
Cc: akpm@linux-foundation.org,
	axboe@kernel.dk,
	brauner@kernel.org,
	david@kernel.org,
	dhowells@redhat.com,
	hch@infradead.org,
	jack@suse.cz,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	miklos@szeredi.hu,
	netdev@vger.kernel.org,
	patches@lists.linux.dev,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org,
	viro@zeniv.linux.org.uk,
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
Date: Wed,  3 Jun 2026 02:07:30 +0300
Message-ID: <20260602230730.138904-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ah9Yle5pd6mD9Ugr@pedro-suse.lan>
References: <ah9Yle5pd6mD9Ugr@pedro-suse.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pedro Falcato <pfalcato@suse.de>:
> (Askar, if I was too hostile, I do sincerely apologize.)

You did nothing wrong.

-- 
Askar Safin
