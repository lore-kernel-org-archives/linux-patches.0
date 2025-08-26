Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8A927EFE7;
	Tue, 26 Aug 2025 13:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214944; cv=none; b=jQuWbbg0DHKCt7vc1d0plWJyjfMlIz1wFbeE2ZQImOoaOhtJ8gDlJ+TK/124lkuDOyFWfw86QnCMdTUNXLQk4uffqjPl6eWusmk3RxjkBJwYo1f0+sM7B1lKQhvxNh49LDz6lr0D1lZCwM07L9/ZP3OgX/COL+u8B6jD+PrPWd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214944; c=relaxed/simple;
	bh=aZHnq+E7dC8ldbmnJYTWLuFXjpdrECcWp8uyFW4ajE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMzBbhYiu7gR2FciyC5jQwOLoVzrwgfPU7Py7J6PpD7VYMydR70LLcbiT/QCnXqJO1ehgIrfU1/6WR4g5LCSjSIHXucQ9cUWCAYdWocU4jiLdCyAK1a6yI5UtbKMThBvXLU+JtOMwb5PFTqfql/plFeYsB5wHy6oLKceyX5rkOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m52nCz5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m52nCz5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1256AC116B1;
	Tue, 26 Aug 2025 13:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214943;
	bh=aZHnq+E7dC8ldbmnJYTWLuFXjpdrECcWp8uyFW4ajE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m52nCz5zxyVOTWHBpuK4OvqS/w0mus7Bn6jcRufqVExGxIixJoOr3JbLOmhqJCBgI
	 7TqzTg25NGLrxVlQSk2LwoxkjXPgRlVznhzhW6JCbUKHsCmzCG/3J/fLAcBKRXwjYe
	 XRBvaHeM1MDZjF+aIzWrCrqUWyvkLQ7E7zvCv9x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 329/482] media: venus: hfi: explicitly release IRQ during teardown
Date: Tue, 26 Aug 2025 13:09:42 +0200
Message-ID: <20250826110938.942632501@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>

commit 640803003cd903cea73dc6a86bf6963e238e2b3f upstream.

Ensure the IRQ is disabled - and all pending handlers completed - before
dismantling the interrupt routing and clearing related pointers.

This prevents any possibility of the interrupt triggering after the
handler context has been invalidated.

Fixes: d96d3f30c0f2 ("[media] media: venus: hfi: add Venus HFI files")
Cc: stable@vger.kernel.org
Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Dikshita Agarwal <quic_dikshita@quicinc.com> # RB5
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -1711,6 +1711,7 @@ void venus_hfi_destroy(struct venus_core
 	venus_interface_queues_release(hdev);
 	mutex_destroy(&hdev->lock);
 	kfree(hdev);
+	disable_irq(core->irq);
 	core->ops = NULL;
 }
 


