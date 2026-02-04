Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3F2421F0C;
	Wed,  4 Feb 2026 14:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217010; cv=none; b=pkRrFlPUwUo4o9ukWa694DXWF8KmSyhERkbhk9KZnSNhoE21GomSpXq5OdSfmLSzDJEWi2nmvl+opAiTKdSklbuPviNaEvqDolJHlaTJiCVD5vU5BUHNY37lLg8AxSM5zMSenqn4E1zqPSlnFYtMVGJUH2mf0E5p1m162yEhs4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217010; c=relaxed/simple;
	bh=8Xystw3eO2vj1ixK4BCLfFJYNRF6p2vZrTw26VPwjpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eT8/ZdZvnxArlv9kd65H3ywjAIZ9hzV6I7vhECumKVDvJUMymQs+4LUd9rnqKGK7lDh2iZnsWoVJ9fMXoxc/27XvkyNZR9wPWrVyASitZ2e5UDbNLpUU2FkBdYzh5cdj3wmX/WjAH+XaV9gW5XeNdk3mGjKTQXMyd2vXaKci5Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRLMx/3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRLMx/3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E4BC4CEF7;
	Wed,  4 Feb 2026 14:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217010;
	bh=8Xystw3eO2vj1ixK4BCLfFJYNRF6p2vZrTw26VPwjpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRLMx/3SGe71Ec2X7ELMa/rq5pwo+0sCm0uqgJwjMGW0OaQA2Q1/uqsIJoXUPeym1
	 nHj6FZ2JToNSOM7qc82AXrvE7uPXHzptEHN5hiluGBnoL+YGO0Efud3ryrzbJ3MMAx
	 JV3yNKqpUwxXrElS9/5Xy7Jl4bgwx30lEDpWfkCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xabier Marquiegui <reibax@gmail.com>,
	Richard Cochran <richardcochran@gmail.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 063/206] ptp: add testptp mask test
Date: Wed,  4 Feb 2026 15:38:14 +0100
Message-ID: <20260204143900.484893882@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xabier Marquiegui <reibax@gmail.com>

[ Upstream commit 26285e689c6cd2cf3849568c83b2ebe53f467143 ]

Add option to test timestamp event queue mask manipulation in testptp.

Option -F allows the user to specify a single channel that will be
applied on the mask filter via IOCTL.

The test program will maintain the file open until user input is
received.

This allows checking the effect of the IOCTL in debugfs.

eg:

Console 1:
```
Channel 12 exclusively enabled. Check on debugfs.
Press any key to continue
```

Console 2:
```
0x00000000 0x00000001 0x00000000 0x00000000 0x00000000 0x00000000
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000
0x00000000 0x00000000 0x00000000 0x00000000 0x00000000 0x00000000
0x00000000 0x00000000 0x00000000 0x00000000
```

Signed-off-by: Xabier Marquiegui <reibax@gmail.com>
Suggested-by: Richard Cochran <richardcochran@gmail.com>
Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 76868642e427 ("testptp: Add option to open PHC in readonly mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ptp/testptp.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index faec606707de6..994ac7988426b 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -121,6 +121,7 @@ static void usage(char *progname)
 		" -d name    device to open\n"
 		" -e val     read 'val' external time stamp events\n"
 		" -f val     adjust the ptp clock frequency by 'val' ppb\n"
+		" -F chan    Enable single channel mask and keep device open for debugfs verification.\n"
 		" -g         get the ptp clock time\n"
 		" -h         prints this message\n"
 		" -i val     index for event/trigger\n"
@@ -187,6 +188,7 @@ int main(int argc, char *argv[])
 	int pps = -1;
 	int seconds = 0;
 	int settime = 0;
+	int channel = -1;
 
 	int64_t t1, t2, tp;
 	int64_t interval, offset;
@@ -196,7 +198,7 @@ int main(int argc, char *argv[])
 
 	progname = strrchr(argv[0], '/');
 	progname = progname ? 1+progname : argv[0];
-	while (EOF != (c = getopt(argc, argv, "cd:e:f:ghH:i:k:lL:n:o:p:P:sSt:T:w:x:Xz"))) {
+	while (EOF != (c = getopt(argc, argv, "cd:e:f:F:ghH:i:k:lL:n:o:p:P:sSt:T:w:x:Xz"))) {
 		switch (c) {
 		case 'c':
 			capabilities = 1;
@@ -210,6 +212,9 @@ int main(int argc, char *argv[])
 		case 'f':
 			adjfreq = atoi(optarg);
 			break;
+		case 'F':
+			channel = atoi(optarg);
+			break;
 		case 'g':
 			gettime = 1;
 			break;
@@ -602,6 +607,18 @@ int main(int argc, char *argv[])
 		free(xts);
 	}
 
+	if (channel >= 0) {
+		if (ioctl(fd, PTP_MASK_CLEAR_ALL)) {
+			perror("PTP_MASK_CLEAR_ALL");
+		} else if (ioctl(fd, PTP_MASK_EN_SINGLE, (unsigned int *)&channel)) {
+			perror("PTP_MASK_EN_SINGLE");
+		} else {
+			printf("Channel %d exclusively enabled. Check on debugfs.\n", channel);
+			printf("Press any key to continue\n.");
+			getchar();
+		}
+	}
+
 	close(fd);
 	return 0;
 }
-- 
2.51.0



