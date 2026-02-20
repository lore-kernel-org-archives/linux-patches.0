Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1322C11EE
	for <patches@lists.linux.dev>; Fri, 20 Feb 2026 16:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771606367; cv=none; b=eKAjqCvnt+nU272JP7W0n/zDZOErMyIt1VxHOdWigoj/z0ey00mnIJCNL5ekB93KDHy7lwPY1RlXpIRpYVES7fV08/htcF70vb7fbNfw3yA64iMNBcnPvzabXTXUd+w7UjvyeXgxClqcrbOqE7aXi9hoOPDs3mGHZSYWhpRkZEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771606367; c=relaxed/simple;
	bh=IqPQ11TxVNwfGfAE21ETJ/ooX/oPSydMfPJi4pktBiw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CmZMktPjDMJ7AWAvvgsju2tJMII3STV+WUEkDWAP6y+/07U5b39zSggEumgBByg8xZA+Rii78BAygIp7E27Vv1r/4kX/1SejbliCDOJS4OwjvOHmkokhttFpv9K+K0uYTWHAfDwuyccWeb6grXB+g+T/zyA6Noi7ipX3pjanrUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FwdgYg4J; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FwdgYg4J"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48371119eacso21938585e9.2
        for <patches@lists.linux.dev>; Fri, 20 Feb 2026 08:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771606364; x=1772211164; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=quHTn17dpdrYevLKDusB6NpnopISHyw9U38mQUOhUW0=;
        b=FwdgYg4J3VHevEJ/wV2xkSaNghyx+nocOtJxdrr0o7yYCi9czPg4wkBh2vzpkXUV4Z
         Jn26xqIJJ6Lw/Ex82YTx0u9ZrNAeK+VvNXUZbkDYEfFHmYuqYKO0PTMlWcy8UJKLghGy
         OnxNnGe5sxiLeAx2mLim/+PnFlqra+z7swR1UtrWQZ43tVd+UHho3jxiEuI2GedhyjnV
         1qdFi5MdJom0X4gzs0SSvvTWWuckdnj5ZF1cXU0BvtHGlNRJDMCvHpeV+uQQbr/JXzJZ
         OdwHbsrlWCqEC3qgFUpZNzuN1/GCuXlMAP7YOQeRAXdfXJfG7albjADpEuvdcTGTA4se
         W08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771606364; x=1772211164;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=quHTn17dpdrYevLKDusB6NpnopISHyw9U38mQUOhUW0=;
        b=DPQC3A8sQgxueK2Ud+9q8d3OGaOtka94mdpS20sW+Py9NyOlqWRvrJCxhjXj44vWK1
         Xj0NiqjwtcdAms9EgARnXAcM6PFjTEx+C4uKKApzG4sYc77qxnZRhZfGwOtngPE8mCip
         wt3v5vGj2HXbh1JdNHxjEOFIbljId+XYlH29JMYT18h46LPSIU1PD7y2pAKKlrbSE6Z0
         xMxpFx1qklQVsDFE/HnkQA0ilXLEc3uTBlBn/IidbmgIcevkWjKaL/1yh2e7b8kIz1D3
         gdFS3WaMSbN4A/25WVCrBuZ/zjxmeFaWxEb+HWOX6r8QEJgKeBw7xBv8Yt3eplWHjSq9
         Icsg==
X-Gm-Message-State: AOJu0YyZrch4Xn+YxbDphSDmtxlQUGlr1EcaUHFxlredRryyrkEvyuh2
	LT2RFKMKz3klN8nvypx9IAK9nODgU51c99anuVcKqEr7RBD18I+ko1WH
X-Gm-Gg: AZuq6aLUExJaIwi2C4Qb8aVgRHGS/yJw8sTfVhaP+nNO3Q7FL4ZDLb6BEhkH+Y3vJT2
	J0F7fD+muZsMJdCpEeL86/47TzkfqvO1cQncTtyCn0KVJgOUT/e4RF5muvYE76gwauj9uozH13p
	xO/b8594u0z3h3hr414hW69w+k2XGEK6vAlkmURgMZEm16y4mtnaVYdT4zBv2D3JOOQQpzCPYav
	A1D6ecDtNb9A+v9i0lXnNZ5Z8F7hFpm/obqBj6oIhwo2Q+15rQKMua92i44J6cYdc5bKLkdyKeN
	IpXErCnHBXxlIUc0Ltlem48rk3R3jIzrM5onFV9musGN7Rs87jlLSGQBi08FwgN2Se1lq01LJRv
	yWWnZYdV5yJXnQa7/z/3+0uzvv+3oOXWn4z026qxLc4lE79lK3U39SrMKd1eiqcnUKAOyJ8PhTd
	dOHvTK0yyj5BPJISbr0Bw=
X-Received: by 2002:a05:600d:640f:20b0:483:9139:4c1d with SMTP id 5b1f17b1804b1-483a9607e3cmr2232775e9.14.1771606363708;
        Fri, 20 Feb 2026 08:52:43 -0800 (PST)
Received: from localhost ([212.73.77.104])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-483a3dfd902sm21265095e9.7.2026.02.20.08.52.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Feb 2026 08:52:43 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] doc: early_userspace_support.rst: trivial fix: directory -> file
Date: Fri, 20 Feb 2026 16:52:38 +0000
Message-ID: <20260220165238.4162735-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Trivial fix.

Signed-off-by: Askar Safin <safinaskar@gmail.com>
---
 .../driver-api/early-userspace/early_userspace_support.rst      | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/driver-api/early-userspace/early_userspace_support.rst b/Documentation/driver-api/early-userspace/early_userspace_support.rst
index 61bdeac1b..60d1e1bc9 100644
--- a/Documentation/driver-api/early-userspace/early_userspace_support.rst
+++ b/Documentation/driver-api/early-userspace/early_userspace_support.rst
@@ -73,7 +73,7 @@ usr/gen_initramfs.sh.  This means that CONFIG_INITRAMFS_SOURCE
 can really be interpreted as any legal argument to
 gen_initramfs.sh.  If a directory is specified as an argument then
 the contents are scanned, uid/gid translation is performed, and
-usr/gen_init_cpio file directives are output.  If a directory is
+usr/gen_init_cpio file directives are output.  If a file is
 specified as an argument to usr/gen_initramfs.sh then the
 contents of the file are simply copied to the output.  All of the output
 directives from directory scanning and file contents copying are

base-commit: 8bf22c33e7a172fbc72464f4cc484d23a6b412ba (mainline)
-- 
2.47.3

