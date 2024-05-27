Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037C715FCE6;
	Mon, 27 May 2024 18:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836378; cv=none; b=EZ2FbjjUITesm1MkmwEAel4PKNHmbt7D/bW8Vl3mUJNo2XDl3iM/k9JD8rTaTJZtGMT/nJs6jBMGUbirCA9ufHUA8hLxq0qtLN5nUlwkrqulvTU4/JWEl+tUQQfn6K8FHbl9P6E3cXt6Q0Hbr3a81qvmpn2xgaASmJjqmDDoCa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836378; c=relaxed/simple;
	bh=JfVBuYZpWp2qyg+gOz0lS4TqrE87g80SVeHfS0+lK20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2EbJX6QGiFWUHoVsNryGEYtPU/87Vtg/HxszBXh8fMeErfB8HQsS1woGOWrtHHbNNEH0aTBa9jstMroKk1RFvuamsWk70jChBUdFEMOWaBU2/lsBm03/kNDP1pAiWFhkGheAgiPFwaWv2FH8MFfyvTfbRN3QcLcXM/yTHGvCss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MGKs9CyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MGKs9CyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB61C2BBFC;
	Mon, 27 May 2024 18:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836377;
	bh=JfVBuYZpWp2qyg+gOz0lS4TqrE87g80SVeHfS0+lK20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MGKs9CyW1arph9fcv7J9x805QKE8ftok9zgiSVu8vFadBsxO3nMMUz6x23Ni4us66
	 7MZKzoHOKI6RV661BtIhEFC4HOCanqdlkkcx5mXFN6M2v1IHB+BNGwa9NhWIc3KLsB
	 LQ5wFtanhIJnBlSPJGtJ3/IlrR8Z0x874MMN3T9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.9 003/427] selftests/ftrace: Fix checkbashisms errors
Date: Mon, 27 May 2024 20:50:50 +0200
Message-ID: <20240527185602.050394262@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit b07b7e2fd51840c7dfffa98c4344ab36195bb8dc upstream.

Fix the below checkbashisms errors. Because of these errors, these tests
will fail on dash shell.

possible bashism in test.d/kprobe/kretprobe_entry_arg.tc line 14 ('function' is useless):
function streq() {
possible bashism in test.d/dynevent/fprobe_entry_arg.tc line 14 ('function' is useless):
function streq() {

Fixes: f6e2253a617c ("selftests/ftrace: Add test cases for entry args at function exit")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../selftests/ftrace/test.d/dynevent/fprobe_entry_arg.tc        | 2 +-
 .../selftests/ftrace/test.d/kprobe/kretprobe_entry_arg.tc       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_entry_arg.tc b/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_entry_arg.tc
index d183b8a8ecf8..1e251ce2998e 100644
--- a/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_entry_arg.tc
+++ b/tools/testing/selftests/ftrace/test.d/dynevent/fprobe_entry_arg.tc
@@ -11,7 +11,7 @@ echo 1 > events/tests/enable
 echo > trace
 cat trace > /dev/null
 
-function streq() {
+streq() {
 	test $1 = $2
 }
 
diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_entry_arg.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_entry_arg.tc
index 53b82f36a1d0..e50470b53164 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_entry_arg.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kretprobe_entry_arg.tc
@@ -11,7 +11,7 @@ echo 1 > events/kprobes/enable
 echo > trace
 cat trace > /dev/null
 
-function streq() {
+streq() {
 	test $1 = $2
 }
 
-- 
2.45.1



