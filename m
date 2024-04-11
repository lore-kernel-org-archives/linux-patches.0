Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD1F79FD;
	Thu, 11 Apr 2024 10:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832457; cv=none; b=arvDG2dlJnW3KnND9KwATxbNDvUz3LuvN5tQImH1xc5C4pt3SiQJRt4x5WT9DiKO3jeioF1RsNI5e1ryBSuEAlRlY0KK1K1CjsyR6cTYTE4YLnKh84AQOjIUK4tbUI2tiW5rBUgOO8Lve+PC/veUf4wgGZFiw2/c9YwYOauu61I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832457; c=relaxed/simple;
	bh=8JOz6/ydZGS0MribYS8bs8gV1rZH0VT+Xsqj03Kkyw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hYVqmf+dAnvpS7GqYmNmohuXdMD2v7nXzCZ/psjC84RXqNINt2Pik89JETodr/qYyp11lyYBjUCKYDaW9rCGdH8xiwKjH/vcfUYhnTY3LhTz1/hF5rYAel9nUrIREHYUH1yZry4EaNwVKeKpIK5ckPZoh/bKNvZ2Cp6dD+KUPsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDzYSwJI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDzYSwJI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5518AC433C7;
	Thu, 11 Apr 2024 10:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832457;
	bh=8JOz6/ydZGS0MribYS8bs8gV1rZH0VT+Xsqj03Kkyw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDzYSwJIk5sqADewR9eqR0anR/ly8DKJnQchpCm4ueu4Jymu1XrfvaiLbQXuJPfbo
	 +wh7e6D5JZTwTOYjDTX+bVd3q1sxkdYj2LI4yh1QX3NAalH8J0KinEnMLAsZsSniiO
	 /FVOA4VwvmTo8mJZmR7sryQx1vw4GlZb4ZQZEfpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hawley <warthog9@eaglescrag.net>,
	"Ricardo B. Marliere" <ricardo@marliere.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 55/83] ktest: force $buildonly = 1 for make_warnings_file test type
Date: Thu, 11 Apr 2024 11:57:27 +0200
Message-ID: <20240411095414.340652443@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo B. Marliere <ricardo@marliere.net>

[ Upstream commit 07283c1873a4d0eaa0e822536881bfdaea853910 ]

The test type "make_warnings_file" should have no mandatory configuration
parameters other than the ones required by the "build" test type, because
its purpose is to create a file with build warnings that may or may not be
used by other subsequent tests. Currently, the only way to use it as a
stand-alone test is by setting POWER_CYCLE, CONSOLE, SSH_USER,
BUILD_TARGET, TARGET_IMAGE, REBOOT_TYPE and GRUB_MENU.

Link: https://lkml.kernel.org/r/20240315-ktest-v2-1-c5c20a75f6a3@marliere.net

Cc: John Hawley <warthog9@eaglescrag.net>
Signed-off-by: Ricardo B. Marliere <ricardo@marliere.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/ktest/ktest.pl | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index e6c381498e632..449e45bd69665 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -836,6 +836,7 @@ sub set_value {
     if ($lvalue =~ /^(TEST|BISECT|CONFIG_BISECT)_TYPE(\[.*\])?$/ &&
 	$prvalue !~ /^(config_|)bisect$/ &&
 	$prvalue !~ /^build$/ &&
+	$prvalue !~ /^make_warnings_file$/ &&
 	$buildonly) {
 
 	# Note if a test is something other than build, then we
-- 
2.43.0



