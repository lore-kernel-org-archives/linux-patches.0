Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0C131690D
	for <patches@lists.linux.dev>; Mon, 19 Jan 2026 11:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768823203; cv=none; b=RcIIiq9mPcyFxvi3OVxk8tsqwOriMn5O+5PD+pWiRjpdDbiYPtNXjRy5Yv3A12PFUaQpw/a+7G1Z3yYrQKGqa6QWpHdnjtC/2xQeq+EpCV8zkW8Bopbjyg3t7b9epHLqYYX62vUnuadj02yb0MvcKZTH2azHz32HeW5jFPzBqW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768823203; c=relaxed/simple;
	bh=W9tl5EGVQQ07JDbhxz9J9n5G9/s3ivfYD8n0emvwRYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLehELvxwscTaONJvBqdbOet/kM3Jtea+Bn6YonM1GrfQ3lW0k6tnniCJWaoFsyjH0++RE+73/QDQN06vJl1LBg1VIQQ5Chna1VAfJxIrtQzvZzC7F4bhWc1mA+qH2k0nyWg6Aca03uQ0G+1E1mTwYQH9bo6nEtk31KpzCzaWXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jakstys.lt; spf=pass smtp.mailfrom=jakstys.lt; dkim=pass (2048-bit key) header.d=jakstys.lt header.i=@jakstys.lt header.b=fIXkQpvS; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=jakstys.lt
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jakstys.lt
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jakstys.lt header.i=@jakstys.lt header.b="fIXkQpvS"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b87003e998bso886774366b.1
        for <patches@lists.linux.dev>; Mon, 19 Jan 2026 03:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jakstys.lt; s=google; t=1768823199; x=1769427999; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W9tl5EGVQQ07JDbhxz9J9n5G9/s3ivfYD8n0emvwRYM=;
        b=fIXkQpvSDdbMjMoqXGWsw64T6PafQnCCPzbenXuezKeFdCEPbrbCH8UBJBxsa3Khn+
         zJ1fgzot935lw9PRzxg/5M+8X8IanIfNejWSkaZlWlXuRf6sDsKRNcnlJ/AUN0gfLqEj
         xQDm9r5gDQ+hAJ8EjjtQIHS5p9nQ7rZ4Qaah1MW0cCGEd5CLWSm4a6S8fcmLtAecLlHx
         mhDVwkxcs8Iq3aimIOi9C5PtXrZ8RD0r2EMqzx08CxyAlrZx3MtSDobNotZOTzr6GTCT
         99Iy5QQegslrvVzKgENtUY0JTzJT9GY3J+9Uflm09nnoIt55E/D5jCi3D8dstBO6v6l3
         rDRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768823199; x=1769427999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W9tl5EGVQQ07JDbhxz9J9n5G9/s3ivfYD8n0emvwRYM=;
        b=G5swPHhP3yBoCa1OlaXs6MIwqSf8kY9tKat+0QmvLGOYD4ag9Ulq7XvZYWRoa2D3tx
         XaNfNy0llnqVJRzunC6KgaanHjL8K1hXuV98I4pHRJfTetoGvgOe+Ris0bXXzvbJqKPf
         XhW0kpxWO1ROfDkf7xWESqKvqBjpEfxJTscSwxyRWdfkOuevDBMcSGl/MAxPdHRtQ/xx
         AYEXTa6V2gdvP9UL54lMqVCBDLcaYJhQRhzgFDKAKYmRrW7iAH2wX7d7H23Uex5OxxkS
         qtc9394AYNMLvZKGH12FeOrB7yuKvBBHUOLGr6ia9ljcGDmDGa87miFVZfL9YFJ5DjnU
         9lSg==
X-Forwarded-Encrypted: i=1; AJvYcCWt6ANWiYvvzbHeZk5JtDwLCaJj3Gl6jKShc9yxKuVHcA4p69HND4hyU9eU5fswkfpLODGx3Jbr@lists.linux.dev
X-Gm-Message-State: AOJu0YzGaCRdup2vl44mKLmYwZ+f5wf7SzXWT7DwDAmHL5EZCVWz3Tr9
	MjJZMOZ7vsr/RKXxhQG5ivsvwD9xnV7OxCWF9guMiVBWsIt31KWfRnJcFrhg6CxeJA==
X-Gm-Gg: AY/fxX49KVs6/12MxodNmwyzfgSBgCXq2z5h/Gvp0iTvlEh6n7w1fn+suCyFnv9gqU3
	fiXlWOElJIim9SZlSBM5xiAyDP99dv0LEUAejTsOEFZ9cPbB7LNRo3bOn7Cid5rZDg4vpMGSozP
	h9LdEg00ch+zXRqU/Qh6ZgAjxNhOKAJ8tCWF/SfwcGqNpGfpuk3C4bQm0AqnuqUXLv/eKwb0rrc
	O0gWOcw3/z8Hs7tIekw49/64pjgN0ncraHc7HrdaBmf/ffdjZCsTeqe6p+ZhHijR0323VMo/lPt
	VXX0aaYtVg1NWS5Y/PW9w94vf0ENEZk1xZo4KAinsUz4IlH4tHnN7rQW6h83DS/ATLrpJZq9Khv
	wpmADfDdaVyGVUgIEt2x5tmKH9C2bGJ6eaCSgpF9PDoyyY/b5AyAAsCPNkEnTeVnCN2NL/bUT5h
	929nIbVOfA8xCGeIumSIGvPgdXVaqMGK4vi7ScAvzCgjAMFWPIrIBvCP6S3laO4T8ehbXTc5vOD
	VOoSJQW59N8KTsJ5Yg9CcaMdiHFSsw=
X-Received: by 2002:a17:907:9694:b0:b87:191f:4fab with SMTP id a640c23a62f3a-b8793a23490mr1008761666b.26.1768823198863;
        Mon, 19 Jan 2026 03:46:38 -0800 (PST)
Received: from localhost ([185.104.176.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b879e2c1be7sm999058266b.67.2026.01.19.03.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 03:46:38 -0800 (PST)
From: =?UTF-8?q?Motiejus=20Jak=C5=A1tys?= <motiejus@jakstys.lt>
To: sashal@kernel.org
Cc: clm@fb.com,
	dsterba@suse.com,
	fdmanana@suse.com,
	linux-btrfs@vger.kernel.org,
	patches@lists.linux.dev,
	robbieko@synology.com,
	stable@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] btrfs: fix deadlock in wait_current_trans() due to ignored transaction type
Date: Mon, 19 Jan 2026 13:46:26 +0200
Message-ID: <20260119114626.1877729-1-motiejus@jakstys.lt>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260112145840.724774-5-sashal@kernel.org>
References: <20260112145840.724774-5-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Dear stable maintainers,

I was about to submit to stable@, but found this earlier email autosel.
However, I don't see it in the queue. What's the right process to get it
included to stable?

This specific patch fixes a production issue: we saw this happening at
least 3 times (across a few thousand servers over the past 4 months
we've moved to btrfs); the last time I was able to capture a kernel
stack trace, which was identical to the one in the patch.

Thanks,
Motiejus
