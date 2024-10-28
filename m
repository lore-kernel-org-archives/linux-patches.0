Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDD457CB6;
	Mon, 28 Oct 2024 00:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730076847; cv=none; b=LjvZ5ay+ackQaGAB7KTjs7zFG+mP5wHOlT+JdhL5GgBuKyi/nfVeumbxo8/T0jiGXRldhzkLZ91KnlI+HB0ToEUrOVLR3Xn0X4b8rO2y/LBlgxUUpoKtyQPLSKFqT8KsgQFsN1VQiY4mna8vk36uhy3KiDUd9R/2jyF1M6NffKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730076847; c=relaxed/simple;
	bh=xf7zQQQESc2au6O1VjTOAPsuKbA5aTJVg3/4oNJ44jI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VFcN/2Nl6WghuDuXoHxJMJzvsg20noZZHgt7SHSlLmGbGzNoQHs3sjrPYFVrmOjD84qTIa3KalKKP1IUHBJplanG5kuXWRom9AZPUNeCIHuu7XwyrRnNOBjEx8uVUhAmKT1K24eTsCIse0g6PWEk2vef4ASmKSj+Y5WOX3zM0+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=W1FVSYMh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="W1FVSYMh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=sHc9vh8NjTk1+qthHPP7uuKNqyJ0ng30sdvaF/oIbu8=; b=W1FVSYMhKOycXosnAsEeQjpH0J
	IPepPkkeXpsIosDe3SjbSQRK3LVMzHtvBg2BVyQafzGqHuwCGUJ7Y+g1XFnc3YvnmT9HjxwFpkaM/
	CZmUShoOmVL/txWTXdoxZr38/NOGfOB8n5iqvIfbGF1fWTgpfc7NedSxtMsMZ/9x8balxvDhquqS6
	LXUSrEduJqP1lpYy2nhhDJFqdv3SaCivrAqfZ0H/Rnd8fc3Rzw25Gyrkk8kY8f08yaS5kFj9miVD5
	TVEe+Swl1hjSwZmUma3Lk7wGId3WsnnNPhxEoTvnFz+VvlkTnOq5DQILMi/nRzj9/+k085LzPAn1F
	M8RhzwLQ==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t5E19-00000009AbQ-0tmQ;
	Mon, 28 Oct 2024 00:53:59 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-doc@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH] Documentation: admin: reorganize kernel-parameters intro
Date: Sun, 27 Oct 2024 17:53:56 -0700
Message-ID: <20241028005356.214369-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reorganize the introduction to the kernel-parameters file to place
related paragraphs together:

- move module info together and near the beginning
- add a Special Handling section for dashes, underscores, double quotes,
  cpu lists, and KMG suffixes
- add a Kernel Build Options section

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/admin-guide/kernel-parameters.rst |   35 ++++++++------
 1 file changed, 22 insertions(+), 13 deletions(-)

--- linux-next-20241025.orig/Documentation/admin-guide/kernel-parameters.rst
+++ linux-next-20241025/Documentation/admin-guide/kernel-parameters.rst
@@ -27,6 +27,16 @@ kernel command line (/proc/cmdline) and
 when it loads a module, so the kernel command line can be used for
 loadable modules too.
 
+This document may not be entirely up to date and comprehensive. The command
+"modinfo -p ${modulename}" shows a current list of all parameters of a loadable
+module. Loadable modules, after being loaded into the running kernel, also
+reveal their parameters in /sys/module/${modulename}/parameters/. Some of these
+parameters may be changed at runtime by the command
+``echo -n ${value} > /sys/module/${modulename}/parameters/${parm}``.
+
+Special handling
+----------------
+
 Hyphens (dashes) and underscores are equivalent in parameter names, so::
 
 	log_buf_len=1M print-fatal-signals=1
@@ -39,8 +49,8 @@ Double-quotes can be used to protect spa
 
 	param="spaces in here"
 
-cpu lists:
-----------
+cpu lists
+~~~~~~~~~
 
 Some kernel parameters take a list of CPUs as a value, e.g.  isolcpus,
 nohz_full, irqaffinity, rcu_nocbs.  The format of this list is:
@@ -82,12 +92,16 @@ so that "nohz_full=all" is the equivalen
 The semantics of "N" and "all" is supported on a level of bitmaps and holds for
 all users of bitmap_parselist().
 
-This document may not be entirely up to date and comprehensive. The command
-"modinfo -p ${modulename}" shows a current list of all parameters of a loadable
-module. Loadable modules, after being loaded into the running kernel, also
-reveal their parameters in /sys/module/${modulename}/parameters/. Some of these
-parameters may be changed at runtime by the command
-``echo -n ${value} > /sys/module/${modulename}/parameters/${parm}``.
+KMG suffixes
+~~~~~~~~~~~~
+
+The [KMG] suffix is commonly described after a number of kernel
+parameter values. These 'K', 'M', and 'G' letters represent the _binary_
+multipliers 'Kilo', 'Mega', and 'Giga', equaling 2^10, 2^20, and 2^30
+bytes respectively. Such letter suffixes can also be entirely omitted.
+
+Kernel Build Options
+--------------------
 
 The parameters listed below are only valid if certain kernel build options
 were enabled and if respective hardware is present. This list should be kept
@@ -212,10 +226,5 @@ a fixed number of characters. This limit
 and is between 256 and 4096 characters. It is defined in the file
 ./include/uapi/asm-generic/setup.h as COMMAND_LINE_SIZE.
 
-Finally, the [KMG] suffix is commonly described after a number of kernel
-parameter values. These 'K', 'M', and 'G' letters represent the _binary_
-multipliers 'Kilo', 'Mega', and 'Giga', equaling 2^10, 2^20, and 2^30
-bytes respectively. Such letter suffixes can also be entirely omitted:
-
 .. include:: kernel-parameters.txt
    :literal:
