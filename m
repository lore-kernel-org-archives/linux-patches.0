Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B3E210F
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD7FC433A7;
	Mon, 24 Apr 2023 13:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343262;
	bh=bim86/uE1tIqWg2QMVnYzCdJ5q4xRgpJ02e8L7ZZCq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOOnaco5coM61fSi7lAUxRbvOffybJQI3cJd3NalIk9tGIpTUFKm+4NNPIU9r9Oen
	 HB1Bo71K8hNzXGk44yaeR86V+pQSMCfrnQsW7/iJ1CjcDwZt1msqk6Ol8pRO+qeIK7
	 quOFEgTjLd1UZYvJsFuPD5mxAVgrriNqHc2XW3Lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.10 28/68] powerpc/doc: Fix htmldocs errors
Date: Mon, 24 Apr 2023 15:17:59 +0200
Message-Id: <20230424131128.717438035@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

commit f50da6edbf1ebf35dd8070847bfab5cb988d472b upstream.

Fix make htmldocs related errors with the newly added associativity.rst
doc file.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Stephen Rothwell <sfr@canb.auug.org.au> # build test
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210825042447.106219-1-aneesh.kumar@linux.ibm.com
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/powerpc/associativity.rst |   29 +++++++++++++++--------------
 Documentation/powerpc/index.rst         |    1 +
 2 files changed, 16 insertions(+), 14 deletions(-)

--- a/Documentation/powerpc/associativity.rst
+++ b/Documentation/powerpc/associativity.rst
@@ -1,6 +1,6 @@
 ============================
 NUMA resource associativity
-=============================
+============================
 
 Associativity represents the groupings of the various platform resources into
 domains of substantially similar mean performance relative to resources outside
@@ -20,11 +20,11 @@ A value of 1 indicates the usage of Form
 bit 2 of byte 5 in the "ibm,architecture-vec-5" property is used.
 
 Form 0
------
+------
 Form 0 associativity supports only two NUMA distances (LOCAL and REMOTE).
 
 Form 1
------
+------
 With Form 1 a combination of ibm,associativity-reference-points, and ibm,associativity
 device tree properties are used to determine the NUMA distance between resource groups/domains.
 
@@ -78,17 +78,18 @@ numa-lookup-index-table.
 
 For ex:
 ibm,numa-lookup-index-table = <3 0 8 40>;
-ibm,numa-distace-table = <9>, /bits/ 8 < 10  20  80
-					 20  10 160
-					 80 160  10>;
-  | 0    8   40
---|------------
-  |
-0 | 10   20  80
-  |
-8 | 20   10  160
-  |
-40| 80   160  10
+ibm,numa-distace-table = <9>, /bits/ 8 < 10  20  80 20  10 160 80 160  10>;
+
+::
+
+	  | 0    8   40
+	--|------------
+	  |
+	0 | 10   20  80
+	  |
+	8 | 20   10  160
+	  |
+	40| 80   160  10
 
 A possible "ibm,associativity" property for resources in node 0, 8 and 40
 
--- a/Documentation/powerpc/index.rst
+++ b/Documentation/powerpc/index.rst
@@ -7,6 +7,7 @@ powerpc
 .. toctree::
     :maxdepth: 1
 
+    associativity
     booting
     bootwrapper
     cpu_families


