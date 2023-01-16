Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD5B6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A82C433D2;
	Mon, 16 Jan 2023 17:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888451;
	bh=TtY+pYwG6Bs1B8dyg1RzzJfOIJ80nQfVVYOszCns9xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4SljXUn1SSloP+j6yuW4TlJIt6JmIkqlgn5pL+dMKH5VfrHGGBBiHMIbuxOL/2ua
	 4Xnq2vOiMHoqk0Sm8z3YRIDbS0KmRucs8Op0XnWt3qKM0Xa+hhgkQtffjsjSl7mjKf
	 hypMD0/id73pkNaRil1hOKa5FjuFLBoTigGCLsn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Jones <tonyj@suse.de>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
	Seeteena Thoufeek <s1seetee@linux.vnet.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4.14 011/338] perf script python: Remove explicit shebang from tests/attr.c
Date: Mon, 16 Jan 2023 16:48:04 +0100
Message-Id: <20230116154821.214339634@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Jones <tonyj@suse.de>

commit d72eadbc1d2866fc047edd4535ffb0298fe240be upstream.

tests/attr.c invokes attr.py via an explicit invocation of Python
($PYTHON) so there is therefore no need for an explicit shebang.

Also most distros follow pep-0394 which recommends that /usr/bin/python
refer only to v2 and so may not exist on the system (if PYTHON=python3).

Signed-off-by: Tony Jones <tonyj@suse.de>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Cc: Seeteena Thoufeek <s1seetee@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20190124005229.16146-5-tonyj@suse.de
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/tests/attr.py |    1 -
 1 file changed, 1 deletion(-)

--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -1,4 +1,3 @@
-#! /usr/bin/env python
 # SPDX-License-Identifier: GPL-2.0
 
 import os


