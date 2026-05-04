Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4CC35A3AD;
	Mon,  4 May 2026 14:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903853; cv=none; b=YR1LZt80/hbq5uMmO6ksxXX3gGEeIt64Ppqsf9ccl/IgjfDekdqf9r5wBke10fgQ36bNgl3ozN0vjVHT31X9LJc2mXIl59aIEZd3NAfgZbCmjhAX3JK5D/h/1tCAtmWBrXdw+ULkpXWs2R4uYlrbo7sEDGo6XugGbKRBVMJGR7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903853; c=relaxed/simple;
	bh=A4007hzedcKP9FBrDLl701jnomveRINphlffDdEx3kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GnCHHEkw8q9Jbq7jmEJzT+GFhz9jjftbJu5y2pmhBPlowSFlAUIIJ0jbzTHaG2LZwWoFLhLSIn6UPg5XNdSKF0J9/CbEATxByfe61HFULskt8PJ5Gmg08Wtqz1THethTPSnVhwquj72464hq4gEL4FvLfl7j+GhPN2GF6Q2e3WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MWEXtGrw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWEXtGrw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13558C2BCB8;
	Mon,  4 May 2026 14:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903853;
	bh=A4007hzedcKP9FBrDLl701jnomveRINphlffDdEx3kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWEXtGrw5EPOPM+B8NbXr3ZjNagvYvdSeu+pTu7abfUxY0H8JT92KoUGS5cyScL++
	 f+EqLXEcVctOmMLaiwKXe7g8CyWF3q8TstynFwVSzF49D8J4T3Fpya6YNB5pxkVn6Z
	 /5yNQQSdw3RtT/YPNLyMPTnBBDMymr1ZQOblOBy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Liebold <simonlie@amazon.de>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.18 086/275] selftests/mqueue: Fix incorrectly named file
Date: Mon,  4 May 2026 15:50:26 +0200
Message-ID: <20260504135146.115680965@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Liebold <simonlie@amazon.de>

commit 64fac99037689020ad97e472ae898e96ea3616dc upstream.

Commit 85506aca2eb4 ("selftests/mqueue: Set timeout to 180 seconds")
intended to increase the timeout for mq_perf_tests from the default
kselftest limit of 45 seconds to 180 seconds.

Unfortunately, the file storing this information was incorrectly named
`setting` instead of `settings`, causing the kselftest runner not to
pick up the limit and keep using the default 45 seconds limit.

Fix this by renaming it to `settings` to ensure that the kselftest
runner uses the increased timeout of 180 seconds for this test.

Fixes: 85506aca2eb4 ("selftests/mqueue: Set timeout to 180 seconds")
Cc: <stable@vger.kernel.org> # 5.10.y
Signed-off-by: Simon Liebold <simonlie@amazon.de>
Link: https://lore.kernel.org/r/20260312140200.2224850-1-simonlie@amazon.de
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mqueue/{setting => settings} | 0
 tools/testing/selftests/mqueue/setting  |    1 -
 tools/testing/selftests/mqueue/settings |    1 +
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename tools/testing/selftests/mqueue/{setting => settings} (100%)

--- a/tools/testing/selftests/mqueue/setting
+++ /dev/null
@@ -1 +0,0 @@
-timeout=180
--- /dev/null
+++ b/tools/testing/selftests/mqueue/settings
@@ -0,0 +1 @@
+timeout=180


