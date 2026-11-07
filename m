Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062527;
	b=BOWZ0T4yqtfg6LXOfGGMKl/sZPZzbKYJ9LFMAYSoL5UBZVH02CQdSwHFLekyI7GVSfsp
	 aDcNunDwtV5ER2eHuZs5Qd/q1aoV+wormUOLyaEJOP1NqmGYPldJBASM7ExMogtRSTISX
	 Jl7DlkixTvuN2sXaJ+LZH5zOwhGjodeComekKNrsEuvqb1C+LQ0pZ9hSLz/jSZ5bJzBXd
	 1YG5qg5ziOUviKNcIW5EjgvJGlmCluVEE+efLGmA6NaSs6wPKtif5JAAzlmAXOQ+WVezf
	 uyWEp8/OXCcDQkeeXWUdxXZpST2gyuU6Gnl1KQkVE3miR4XyqdcIsqZtML+HMRvEWWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kTC9+J3W8Y7BuM/sYq1zOzw5TLE9JfAMmpzvs/lFChw=;
	b=xOFbczsOUYkU9TDMH7NUxAQLVrbP9IO9D9m00QIkRhQi3XR6HJFY8fcoEOKBTPQhiQy0
	 8LFD1UgFxayqnqHqlACi6U8OEaCMWYKElhQ5zfpiq7hcP8dXyrwBp0v82xQsdoD6YytlM
	 lk9R22nYoX3rx8JHyissx66mt4+pYVuJJinTtrW1h0MwITN22b61XahFncKor2dJIcq+H
	 W1iyho9iyyRuLyX4Kg5DzdGgJ3F4CDJ6brlkpe4N8WLGEGi3lcab0/z7J/MMA9WOocZ4F
	 pCdaQKJ8+4QSdAu+rub+FzMlSWqEVo0Ml7DmpPQPB1r7M80qhX5ybWyex5MVWJykm/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oYhCCv3G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2196606D80F;
	Sat,  7 Nov 2026 14:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oYhCCv3G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8000B1F0089F;
	Sat,  7 Nov 2026 14:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062526;
	bh=kTC9+J3W8Y7BuM/sYq1zOzw5TLE9JfAMmpzvs/lFChw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYhCCv3GTGYge8921a+JpnIt2a9WjOsG1yEREnkiCac8k6l0H2Jajihz5Svks2+hv
	 7DKZsANbnfzu5RXBLeBJGkFgsUq7d99YxmJ1bSMg4mzZ6jDZ1U4lQ1VuRIAlLfaHss
	 t7pfK97Y/omITM8iefiHsMt0QTf+40O9s9Nxt0q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1402/1536] Documentation: hyperv: Update documentation for sending VMBus packets
Date: Sat,  7 Nov 2026 08:56:58 -0500
Message-ID: <20261107135037.204761141@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhkelley58@gmail.com>

[ Upstream commit 6a3d77a0a8cf69cf3d234305e6711729eb5d10c4 ]

The functions for sending VMBus packets have changed.
vmbus_sendpacket_mpb_desc() can target multiple ranges, and
vmbus_sendpacket_pagebuffer() has been removed. vmbus_sendpacket_getid()
has been added. Update the documentation accordingly.

Fixes: 45a442fe369e ("Drivers: hv: vmbus: Remove vmbus_sendpacket_pagebuffer()")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Reviewed-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/virt/hyperv/vmbus.rst | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/hyperv/vmbus.rst b/Documentation/virt/hyperv/vmbus.rst
index 1dcef6a7fda3f..7ee27faf5e5bd 100644
--- a/Documentation/virt/hyperv/vmbus.rst
+++ b/Documentation/virt/hyperv/vmbus.rst
@@ -141,14 +141,15 @@ Three functions exist to send VMBus channel messages:
 
 1. vmbus_sendpacket():  Control-only messages and messages with
    embedded data -- no GPAs
-2. vmbus_sendpacket_pagebuffer(): Message with list of GPAs
-   identifying data to transfer.  An offset and length is
-   associated with each GPA so that multiple discontinuous areas
-   of guest memory can be targeted.
-3. vmbus_sendpacket_mpb_desc(): Message with list of GPAs
-   identifying data to transfer.  A single offset and length is
-   associated with a list of GPAs.  The GPAs must describe a
-   single logical area of guest memory to be targeted.
+2. vmbus_sendpacket_getid(): Similar to vmbus_sendpacket() but returns
+   a transaction ID that is matched against a reply from the Hyper-V
+   host. Useful when the struct completion (or other rendezvous data)
+   must reside on the caller's stack. By invalidating the transaction
+   ID before exiting the function due to a timeout or other error, a
+   late arriving interrupt is assured to not trash the stack.
+3. vmbus_sendpacket_mpb_desc(): Message with one or more data ranges
+   to target. Each range consists of a single offset and length plus
+   a list of GPAs that describe a logical area of guest memory.
 
 Historically, Linux guests have trusted Hyper-V to send well-formed
 and valid messages, and Linux drivers for synthetic devices did not
-- 
2.53.0



