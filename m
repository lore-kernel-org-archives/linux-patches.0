Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016458;
	b=nHmNyxh0ePa3M1JrsBOnPRPlr0f6dqck7maPmfgMei060kGpassuqyuoLbrU96Z8Dkbf
	 X3UmLkh4lQEASkP+kBnWNSYafbnXN8c4iPAMl4ICTPpS7bLjvo6xqOo0KG04lwhJFc/TT
	 VW/Gf+hTtkQVf/9PQiW7YnnirrlM0rL/hNoWdzrDaEXp9nyxmi+ndr34jJlYCBSQeb6cQ
	 YGQSTTt0PwoSnrRu27bGRJHwOOA5rzSeGJjmiWzB4KkCCd9INaObBx8iSnAH45Bkff3kR
	 MbUF+J8s0/U6XDmjtTxsOpw5VvkhwJaFxcCSX0P9jp8VlGk98LZd62LkAG/rKbsD8jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lmxrTPiNlb7eqLlVmkjj+oF2rMY4yr2OXknVrm8ph5A=;
	b=2c0O+Vz6o6z6fkq8fDNA/NDZQzoDuxZnbRblNiRkq7LDIg8T0F2gSJ7M48zd5sW6snZT
	 d+Y4psDZa8lnq5AglzI9fa7/Ic2CSeAp/NAQqcIvGRxJXnG6sfUwx8VC53v7W/RWO3TMR
	 B9VTs4h8IXlaO+JWEfqFGKtY1xgBboCrQ3VCZEzSD9ywx+CyvXGmzvy4vuusRC3sPofDw
	 OSuYDGtE91zzUGkVS3FIRE77THyo12Meus1mUt0rfUOmdYJYRl+7DRMVeIkyG1DbODCXz
	 FJWsE9tlH+jzOZ5pamhdg+RTT+Lr+KtwA5BZE25qSCD9ku/8GY5GxwLEadG7p/6DKSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jE1IcHNl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ECA606A31C;
	Wed, 18 Nov 2026 15:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jE1IcHNl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501481F000C5;
	Wed, 18 Nov 2026 15:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016457;
	bh=lmxrTPiNlb7eqLlVmkjj+oF2rMY4yr2OXknVrm8ph5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jE1IcHNlwjS+HCUCpW/HqMQC30+fifYJ76GXSTEddqR0xAf8eTS/Q99zOq6DuAUVT
	 Wf693i24EhHtWiQC3j/SdozUT2KheRiW3vPwxuVAMNvMOYQrP8k02PvsyHf+yn+Vvo
	 iFyxvwuFCnUr0Buu3PJhmV/uC98UGpEuUGLhIrGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0536/2651] perf test: Skip data_type_profiling when the PMU cannot record memory events
Date: Wed, 18 Nov 2026 15:29:36 +0100
Message-ID: <20261118150307.055448810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 29f320d221c1c4c082c7eafb2251fedf8a4868ec ]

The test's only guard matches "failed: no PMU supports the memory
events", but a PMU that has memory events and refuses them per-thread,
such as AMD IBS on kernels without the swfilt filter, falls through:
the script runs under 'set -e' and the bare 'perf mem record' aborts it
through the EXIT trap, reporting a signal that never happened and
turning "this PMU cannot record these events" into a test failure.

Skip when a trivial per-thread 'perf mem record' fails, and put the
record and annotate calls in the condition of an 'if', where 'set -e'
leaves them alone, so the remaining cases report their own failures
instead of the first one aborting the run.

Fixes: f60a5c22967b ("perf tests: Test annotate with data type profiling and rust")
Acked-by: Namhyung Kim <namhyung@kernel.org>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/data_type_profiling.sh | 46 +++++++++++++++----
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/tools/perf/tests/shell/data_type_profiling.sh b/tools/perf/tests/shell/data_type_profiling.sh
index eca694600a047..a916c410274aa 100755
--- a/tools/perf/tests/shell/data_type_profiling.sh
+++ b/tools/perf/tests/shell/data_type_profiling.sh
@@ -19,6 +19,15 @@ perfout=$(mktemp /tmp/__perf_test.perf.out.XXXXX)
 perf mem record -o /dev/null -- true  2>&1 | \
   		grep -q "failed: no PMU supports the memory events" && exit 2
 
+# Skip if per-thread mem record is not supported on this PMU (e.g. AMD IBS
+# needs system-wide '-a'): it is what the test records with below, and a
+# failing record must not be reported as a test failure.
+if ! perf mem record -o /dev/null -- true 2>/dev/null
+then
+  echo "Skip: cannot record memory events on this PMU"
+  exit 2
+fi
+
 cleanup() {
   rm -rf "${perfdata}" "${perfout}"
   rm -rf "${perfdata}".old
@@ -52,25 +61,42 @@ test_basic_annotate() {
     index=1 ;;
   esac
 
+  # Under 'set -e' a bare failing command aborts the script through the EXIT
+  # trap, so the commands that report a failure have to be the condition of
+  # an 'if' for that reporting to ever happen.
   if [ "x${mode}" == "xBasic" ]
   then
-    perf mem record -o "${perfdata}" ${testprogs[$index]} 2> /dev/null
+    if ! perf mem record -o "${perfdata}" ${testprogs[$index]} 2> /dev/null
+    then
+      echo "${mode} annotate [Failed: perf record]"
+      err=1
+      return
+    fi
   else
-    perf mem record -o - ${testprogs[$index]} 2> /dev/null > "${perfdata}"
-  fi
-  if [ "x$?" != "x0" ]
-  then
-    echo "${mode} annotate [Failed: perf record]"
-    err=1
-    return
+    if ! perf mem record -o - ${testprogs[$index]} 2> /dev/null > "${perfdata}"
+    then
+      echo "${mode} annotate [Failed: perf record]"
+      err=1
+      return
+    fi
   fi
 
   # Generate the annotated output file
   if [ "x${mode}" == "xBasic" ]
   then
-    perf annotate --code-with-type -i "${perfdata}" --stdio --percent-limit 1 2> /dev/null > "${perfout}"
+    if ! perf annotate --code-with-type -i "${perfdata}" --stdio --percent-limit 1 2> /dev/null > "${perfout}"
+    then
+      echo "${mode} annotate [Failed: perf annotate]"
+      err=1
+      return
+    fi
   else
-    perf annotate --code-with-type -i - --stdio 2> /dev/null --percent-limit 1 < "${perfdata}" > "${perfout}"
+    if ! perf annotate --code-with-type -i - --stdio 2> /dev/null --percent-limit 1 < "${perfdata}" > "${perfout}"
+    then
+      echo "${mode} annotate [Failed: perf annotate]"
+      err=1
+      return
+    fi
   fi
 
   # check if it has the target data type
-- 
2.53.0



