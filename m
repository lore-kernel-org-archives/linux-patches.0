Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E7C1CC17A;
	Tue, 29 Oct 2024 18:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730225007; cv=none; b=SaC99y8bf/JpkjtFijDxF1xzaId3dppdoV4iXldQgcTa/0KjHtms1fYOtWKw+i9HDodbHpXcYdGSCP2udMBI3YuEeiBjq7YyjVw+/5RAkqZLzTFKXz9tyEiO5rj82RCP8+pMqHemUQSSEmetTRAf6qrMHK/nwqG7BQlbFLwwc9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730225007; c=relaxed/simple;
	bh=C/GT3/MV2r2ZFBy8la1FZVSQ41bIaf1c7/loELK6fWY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p8ZfYy1DRawFx5JnQnd6CfEWBXgegFGFb8MuPefSw6eKg5y+z085LfpMsg0QOkJtE8vdYq9rXZWbDOJbn4Yrm+5A1+bJ6GcqVylpMvcxD2eSs+zTZPu6Tz0QHdu61R/qMzQDu6D2pkWAiyjYafFF0w4DY2t8DoDhrPw3Ppim9Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ND5lZs3n; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ND5lZs3n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=lwbJmh1PCl4h+C9x95tF2TgfKWDeqqY9+Q5LABG3WUQ=; b=ND5lZs3nf8RPSKRSA48epip7WN
	QBiINdDqPV/J4uBzg/c8uqxWyOoQRH8PrVBvu8fhKOP4M4hjOwWSmC+RPoVXFh+HiexaSrIPX9a/X
	s5TTMekEHssMglS1XcsYX94hqC0zrMeAHzABdFMEByLPIAlMewFUyvNFTeEVpYot+nCUt4NxoTCw9
	J+V5Y1lBYl8VNKFKQO3d18RoZMqJLS/Ny/E/7YfyyLfL8APgcbIZkexaXo9Q/6X113F0aYaYVzKiH
	1smUB6UyhHd9d3VrYU3LdALaBlnConj7la+/iflG3LLZYgZV6lZU8cpgeF7OGuaT6FhQmWsbLqpNG
	TMI/GmzA==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1t5qYt-0000000FRPw-1aBx;
	Tue, 29 Oct 2024 18:03:23 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-doc@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH v2] Documentation: admin: reorganize kernel-parameters intro
Date: Tue, 29 Oct 2024 11:03:20 -0700
Message-ID: <20241029180320.412629-1-rdunlap@infradead.org>
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
  cpu lists, and metric (KMG) suffixes. Expand the KMG suffixes to
  include TPE as well.
- add a Kernel Build Options section

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
---
 Documentation/admin-guide/kernel-parameters.rst |   36 ++++++++------
 1 file changed, 23 insertions(+), 13 deletions(-)

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
@@ -82,12 +92,17 @@ so that "nohz_full=all" is the equivalen
 The semantics of "N" and "all" is supported on a level of bitmaps and holds for
 all users of bitmap_parselist().
 
-This document may not be entirely up to date and comprehensive. The command
-"modinfo -p ${modulename}" shows a current list of all parameters of a loadable
-module. Loadable modules, after being loaded into the running kernel, also
-reveal their parameters in /sys/module/${modulename}/parameters/. Some of these
-parameters may be changed at runtime by the command
-``echo -n ${value} > /sys/module/${modulename}/parameters/${parm}``.
+Metric suffixes
+~~~~~~~~~~~~~~~
+
+The [KMG] suffix is commonly described after a number of kernel
+parameter values. 'K', 'M', 'G', 'T', 'P', and 'E' suffixes are allowed.
+These letters represent the _binary_ multipliers 'Kilo', 'Mega', 'Giga',
+'Tera', 'Peta', and 'Exa', equaling 2^10, 2^20, 2^30, 2^40, 2^50, and
+2^60 bytes respectively. Such letter suffixes can also be entirely omitted.
+
+Kernel Build Options
+--------------------
 
 The parameters listed below are only valid if certain kernel build options
 were enabled and if respective hardware is present. This list should be kept
@@ -212,10 +227,5 @@ a fixed number of characters. This limit
 and is between 256 and 4096 characters. It is defined in the file
 ./include/uapi/asm-generic/setup.h as COMMAND_LINE_SIZE.
 
-Finally, the [KMG] suffix is commonly described after a number of kernel
-parameter values. These 'K', 'M', and 'G' letters represent the _binary_
-multipliers 'Kilo', 'Mega', and 'Giga', equaling 2^10, 2^20, and 2^30
-bytes respectively. Such letter suffixes can also be entirely omitted:
-
 .. include:: kernel-parameters.txt
    :literal:
