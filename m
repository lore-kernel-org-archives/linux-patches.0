Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E061448F3;
	Thu, 11 Apr 2024 10:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829977; cv=none; b=HlVdZn0j4x7r41Ap3jV7VaD7CcvjzUIzujov8TdmCu6iNaBVDv8ZJlv4sb4THwiW6aWlgs5/nwR2WTtcLHGpDntbg5nVqCStMFSlHD1DpjT9UYacSn74J974Y8oTmlZ2ZCQnuZHElaGS/FfoeBQBz6MIKHIrQutBS1Bh/K7PNcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829977; c=relaxed/simple;
	bh=w3ZDho3WElwqDRCF0AdwiHyO45Td2yAoz4g9KbYx9nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mT90HVYnU92+Nbe5oQ69fK6s2zlUxdiqRt6xhDK3qdgwU4ocgKXYv4wUSEuyYqO17yKB1lSsLDR++hGvVJm6nTXk9bgqUV0B7vHlngDogEthci7dyXfWWwu6j9zRDIyCWLDnq38SfXXyTpEcO5+Y/p3O66uvQVo4pJW384ZZzbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVJjPl4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVJjPl4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38920C433F1;
	Thu, 11 Apr 2024 10:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829977;
	bh=w3ZDho3WElwqDRCF0AdwiHyO45Td2yAoz4g9KbYx9nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVJjPl4IBaY3X3L8gF5B8bRmdKg+G+e/UQFGw5Lc/k4l9qpr6p19iViYinBdxkS6C
	 mIGNpeXzk+I+yWwbkKRfAl8mVWwPOcBGgxXxbUEnJQ2z4F5IXXvWguY5LApWVQQsqW
	 1/s3gV7ddyXvQvNkcHO4mm2X2lvn6XsmdyGnt8DI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hawley <warthog9@eaglescrag.net>,
	"Ricardo B. Marliere" <ricardo@marliere.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 162/175] ktest: force $buildonly = 1 for make_warnings_file test type
Date: Thu, 11 Apr 2024 11:56:25 +0200
Message-ID: <20240411095424.441611560@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 128a7fe45a1e3..a29d9e125b00b 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -765,6 +765,7 @@ sub set_value {
     if ($lvalue =~ /^(TEST|BISECT|CONFIG_BISECT)_TYPE(\[.*\])?$/ &&
 	$prvalue !~ /^(config_|)bisect$/ &&
 	$prvalue !~ /^build$/ &&
+	$prvalue !~ /^make_warnings_file$/ &&
 	$buildonly) {
 
 	# Note if a test is something other than build, then we
-- 
2.43.0



