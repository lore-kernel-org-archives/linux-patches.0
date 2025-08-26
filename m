Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74700352067;
	Tue, 26 Aug 2025 14:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217504; cv=none; b=akBmae1xY5qhAOl60x2O13BbrdRr0xNZ80K2pi7Q+aLqsBJpskUJ39Nyo0MAwRVYtA1AiottBAby6wyzcaZ42OF21ByvtZcBwa8vjlNgBfjRO36b/76ld6fDOh9NfPcvhqjSjsl6fbPOdSuuMmW0dnO4AxjPA6BU9WoQpPAkScc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217504; c=relaxed/simple;
	bh=5VtOfRlSdRIQj+6n0MfTNYaOys5cMt5mfj3XmtJVR1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M6e9nsDyzDny9tytAwk7P4bvXCTiWrV4kh/ECeI/bEd/aoQ/27O9FSqtJSzdxyjAVvUCXCMgiUvuz87BlhOlKhkWo9eReIygrQxVuy9aNRFJ49cAUXr57nI4tD26VMOptychhEJetYs3NWgD7iOsTsnzO6DTBTa/hT+ktYYBvvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8eftdWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8eftdWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48C6C4CEF1;
	Tue, 26 Aug 2025 14:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217503;
	bh=5VtOfRlSdRIQj+6n0MfTNYaOys5cMt5mfj3XmtJVR1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8eftdWLGvp6lx3DZHyKfavUSra7wF1pDmZrAPxfnfTGBd5UpRvo1VPTT+hx82T8d
	 B2fpVPYUfxInoP7rzP1YYn3WQa53fxbKiFh98olW4nBn/8SUhj4bTYo41HTlbd+kzB
	 PRJyncVbg2kfI+ZMhXTkiUwAXqc2LUdAO21Io7/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/523] soundwire: stream: restore params when prepare ports fail
Date: Tue, 26 Aug 2025 13:05:46 +0200
Message-ID: <20250826110927.855997028@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit dba7d9dbfdc4389361ff3a910e767d3cfca22587 ]

The bus->params should be restored if the stream is failed to prepare.
The issue exists since beginning. The Fixes tag just indicates the
first commit that the commit can be applied to.

Fixes: 17ed5bef49f4 ("soundwire: add missing newlines in dynamic debug logs")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://lore.kernel.org/r/20250626060952.405996-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/stream.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/stream.c b/drivers/soundwire/stream.c
index a377c3d02c55..e4ceaea331a2 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -1555,7 +1555,7 @@ static int _sdw_prepare_stream(struct sdw_stream_runtime *stream,
 		if (ret < 0) {
 			dev_err(bus->dev, "Prepare port(s) failed ret = %d\n",
 				ret);
-			return ret;
+			goto restore_params;
 		}
 	}
 
-- 
2.39.5



