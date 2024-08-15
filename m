Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BFE1AD40D;
	Thu, 15 Aug 2024 14:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732951; cv=none; b=f++ic23yHHGFKaCLxcTSPE1wBg+wYRVME4nuWkJ0UQImWrx77OwX1dBsoQ0BBFO1DGJqLG8okejTbXFM80l6ZQDu/auxfR1pu6D49tv929sqkItlNAp8RU/MhSNPzyxQ5qJUqbBK8DVt8khmsuEwhTUPIN4GCj8eIYFB92SWBfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732951; c=relaxed/simple;
	bh=2R3kTzz01OEx2TADzQmP6kKb+9ali87j4z20ue/QJjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2pgR4uU8QBrwTDU6n25JiWUZTNE8yLLKnT4zQtKHKggeoL3utCJg323iHzNWmNrQZplXGX6xJJ0lGZkLQeOWeSH/bvoD+6vocl4hORmCixt5WrhlHTr5QsEKywDGQcqb5cDg1LAI+XkCznnDZEDPy3Le6Uq9JIgZl40NrYDZM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPloKr9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPloKr9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7525C4AF0D;
	Thu, 15 Aug 2024 14:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732951;
	bh=2R3kTzz01OEx2TADzQmP6kKb+9ali87j4z20ue/QJjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPloKr9m0CHvuS1v1DNEkyMLixtPpCB7jA0ln3WkHGFPpbZB6brs3gHZ8gHfHN/mC
	 HuKqvh+w1WeysAJeszWi0NMGRjF57TGHiaqfXOPsBK7h4Q54y9HWz+WvnZxAiOLs2u
	 WtKzHLzFrDvAir5QqFpjL/xQHQIq06sql6tQTrKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 336/352] Add gitignore file for samples/fanotify/ subdirectory
Date: Thu, 15 Aug 2024 15:26:42 +0200
Message-ID: <20240815131932.449119768@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit c107fb9b4f8338375b3e865c3d2c1d98ccb3a95a ]

Commit 5451093081db ("samples: Add fs error monitoring example") added a
new sample program, but didn't teach git to ignore the new generated
files, causing unnecessary noise from 'git status' after a full build.

Add the 'fs-monitor' sample executable to the .gitignore for this
subdirectory to silence it all again.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 samples/fanotify/.gitignore |    1 +
 1 file changed, 1 insertion(+)
 create mode 100644 samples/fanotify/.gitignore

--- /dev/null
+++ b/samples/fanotify/.gitignore
@@ -0,0 +1 @@
+fs-monitor


